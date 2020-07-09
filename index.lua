-- dependencies
local pprint = require("pprint")

local alias = require("alias")
local thread = require("thread")
local uv = require "uv"
local Scraper = require "scraper"
local html_parser = require "htmlparser"
local discordia = require("discordia")
local client = discordia.Client()
-- local url = io.read()
local f = io.input("config.txt")

local token = f:read()

local url = "https://csgostash.com/"

local dev = true

print("Started...")

local scraper = Scraper:new(nil)

--htmlparser_looplimit = 2000

local function random(m, n)
    return math.random(m, n), math.random(m, n), math.random(m, n)
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function table.filter(t, f)
    local a = {}
    local b = false
    for i = 1, #t, 1 do
        if t[i] ~= nil then
            _, b = pcall(f, i, t[i])
        end
        if b == true then
            table.insert(a, t[i])
        end
    end
    return a
end

local function format_alias(t)
    local s = [[]]
    for i = 1, #t, 1 do
        s = s .. t[i] .. "\n"
    end
    return s
end

local function send_embed(channel, q)
    local r, g, b = random(10000, 20000)
    local listings = q.steam_info.listings
    local description = "[Steam Listings](" .. listings .. ")"
    channel:send {
        embed = {
            title = "CSGO Skins",
            fields = {
                {name = "Skin Name", value = q.name, inline = true},
                {name = "Quality", value = q.quality, inline = true},
                {name = "Price", value = q.price.price, inline = true},
                {name = "Stat Strak Price", value = q.price.factory_price, inline = true}
            },
            description = description,
            color = discordia.Color.fromRGB(r, g, b).value,
            timestamp = discordia.Date():toISO("T", "Z"),
            image = {url = q.src},
            footer = {icon_url = client.user.avatarURL, text = client.user.username}
        }
    }
end

local function send_alias(channel)
    local r, g, b = random(10000, 20000)

    local pistol = format_alias(alias.pistol)

    local rifle = format_alias(alias.rifles)
    local smg = format_alias(alias.smg)

    local heavy = format_alias(alias.heavy)
    local knives = format_alias(alias.knives)

    local embed = {
        title = "Skin Alias",
        fields = {
            {name = "Pistol", value = pistol, inline = true},
            {name = "Rifle", value = rifle, inline = true},
            {name = "Smg", value = smg, inline = true},
            {name = "Heavy", value = heavy, inline = true},
            {name = "Knives", value = knives, inline = true}
        },
        color = discordia.Color.fromRGB(r, g, b).value,
        timestamp = discordia.Date():toISO("T", "Z"),
        footer = {icon_url = client.user.avatarURL, text = client.user.username}
    }
    channel:send {embed = embed}
end

local function is_development(guild)
    return guild.name == "music server" and dev == true
end

local function start_backgroundThread(discord_data)
    local worker =
        thread.work(
        function(url)
            -- local u = url
            local Scraper = require "scraper"
            local serpent = require "serpent"
            local scraper = Scraper:new(nil)
            print("done")
            local elements, html = scraper:get_elements("https://csgostash.com/weapon/CZ75-Auto")

            -- local q = scraper:get_index(elements, serpent)

            -- return q, html
        end,
        function(q, html)
            -- q = load(q)()

            -- local root = html_parser.parse(html)

            -- local elements, _ = root:select(".center-block")
            -- for i, e in ipairs(elements) do
            --     local v = scraper.get_quality(e.parent.parent.nodes)
            --     if v ~= "" then
            --         q[i].quality = v
            --     end
            -- end
            -- coroutine.wrap(
            --     function()
            --         local channel = client:getChannel(discord_data.channel_id)
            --         q =
            --             table.filter(
            --             q,
            --             function(i, v)
            --                 if v.name:match(discord_data.item) then
            --                     return true
            --                 end
            --             end
            --         )
            --         if q[1] ~= nil then
            --             pcall(send_embed, channel, q[1])
            --         else
            --             channel:send("`Item " .. discord_data.item .. " " .. "not found`")
            --         end
            --         collectgarbage()
            --     end
            -- )()
            -- channel:send(t[1].quality)
        end
    )
    worker:queue(discord_data.url)
end

client:on(
    "ready",
    function()
        print("Logged in as " .. client.user.username)
    end
)
client:on(
    "messageCreate",
    function(message)
        is_development(message.guild)
        if message.author.bot ~= true then
            if message.content:match("!get") then
                local split = string.split(message.content, " ")
                if #split < 3 or #split < 2 then
                    message.channel:send("`Not enough arguments for !get`")
                else
                    -- q =
                    --     table.filter(
                    --     q,
                    --     function(i, v)
                    --         if v.name:match(split[3]) then
                    --             return true
                    --         end
                    --     end
                    -- )
                    -- if q[1] ~= nil then
                    --     pcall(send_embed, message.channel, q[1])
                    -- else
                    --     message.channel:send("`Item " .. split[3] .. " " .. "not found`")
                    -- end
                    -- collectgarbage()
                    --   http.url = "https://csgostash.com/" .. "weapon/" .. alias.alias[split[2]]
                    -- local q = scraper.get_index(scraper, get_elements())
                    local url = "https://csgostash.com/" .. "weapon/" .. alias.alias[split[2]]
                    start_backgroundThread(
                        {url = url, name = message.name, channel_id = message.channel.id, item = split[3]}
                    )
                end
            else
                if message.content:match("!alias") then
                    collectgarbage()
                    pcall(send_alias, message.channel)
                else
                    if message.content:match("!featured") then
                        -- local url = "https://csgostash.com/"
                        -- local q = scraper.get_index(scraper, get_elements(url))
                        -- for i = 1, #q, 1 do
                        --     pcall(send_embed, message.channel, q[i])
                        -- end
                        collectgarbage()
                    else
                        if message.content:match("!commands") then
                            message.channel:send(
                                [[`!get gets skin data from specific category - example !get p2000 Fire Elemental` \n`!alias shows skin aliases for !get command` \n`!featured gets all the featured skins`]]
                            )
                        end
                    end
                end
            end
        end
        collectgarbage()
    end
)
-- body

client:run(token)
