-- dependencies
local pprint = require("pprint")
local html_parser = require("htmlparser")
local curl = require("curl")
local alias = require("alias")
local Scraper = require("scraper")
local discordia = require("discordia")
local client = discordia.Client()
-- local url = io.read()
local f = io.input('config.txt')

local token = ""

for v in f:lines() do
    token = v
end

local url = "https://csgostash.com/"


print("Started...")

local html = ""

local http = curl:new(nil, url)

local scraper = Scraper:new()

pprint(http.url)

local function get_elements()
    for c in http:get("curl ") do
        html = html .. c
    end
    -- pprint(html)
    local root = html_parser.parse(html)

    return root:select(".center-block")
end

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
            b = f(i, t[i])
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
            {name = "Pistol", value = pistol},
            {name = "Rifle", value = rifle},
            {name = "Smg", value = smg},
            {name = "Heavy", value = heavy},
            {name = "Knives", value = knives}
        },
        color = discordia.Color.fromRGB(r, g, b).value,
        timestamp = discordia.Date():toISO("T", "Z"),
        footer = {icon_url = client.user.avatarURL, text = client.user.username}
    }
    channel:send {embed = embed}
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
        if message.author.bot ~= true then
            if message.content:match("!get") then
                local split = string.split(message.content, " ")
                if #split < 3 or #split < 2 then
                    message.channel:send("`Not enough arguments for !get`")
                else
                    http.url = "https://csgostash.com/" .. "weapon/" .. alias.alias[split[2]]
                    local q = scraper.get_index(scraper, get_elements())
                    q =
                        table.filter(
                        q,
                        function(i, v)
                            if v.name:match(split[3]) then
                                return true
                            end
                        end
                    )
                    if q[1] ~= nil then
                        collectgarbage()
                        send_embed(message.channel, q[1])
                    else
                        message.channel:send("`Item " .. split[3] .. " " .. "not found`")
                    end
                end
            else
                if message.content:match("!alias") then
                    collectgarbage()
                    send_alias(message.channel)
                else
                    if message.content:match("!featured") then
                        collectgarbage()
                        http.url = "https://csgostash.com/"
                        local q = scraper.get_index(scraper, get_elements())
                        for i = 1, #q, 1 do
                            if q[i] ~= nil then
                                send_embed(message.channel, q[i])
                            end
                        end
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

client:run(token)
