-- dependencies
local pprint = require("pprint")
local html_parser = require("htmlparser")
local curl = require("curl")
local alias = require("alias")
local ffi = require("ffi")
local fs = require("fs")
local Scraper = require("scraper")
local discordia = require("discordia")
local client = discordia.Client()
-- local url = io.read()
local f = io.input("config.txt")

local token = f:read()

local url = "https://csgostash.com/"

local dev = true

print("Started...")

local clib = ffi.load("threading/target/release/librust_threading.so")

ffi.cdef [[
  typedef void (*cb)(const char* v);
  void start_thread(const char* v,int duration,void (*)(const char* v,int len));
  void spawn_process(const char* process,const char* args);
  void connect_to_domain_socket(const char* v,const char* data, void (*)(const char* v,int len));
  int poll(struct pollfd *fds, unsigned long nfds, int timeout);
]]

-- clib.spawn_process("python3","python/index.py")

local html = ""

local http = curl:new(nil, url)

local scraper = Scraper:new()

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
    local description = "[Steam Listings](" .. listings .. ")" .. "\n" .. q.listing.listings
    local embed = {
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
    coroutine.wrap(
        function()
            channel:send {
                embed = embed
            }
        end
    )()
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

-- local function is_development(guild)
--     return guild.name == "music server" and dev == true
-- end

local function interp(s, tab)
    return (s:gsub(
        "($%b{})",
        function(w)
            return tab[w:sub(3, -2)] or w
        end
    ))
end

getmetatable("").__mod = interp

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
                    -- clib.start_thread(
                    --     [[
                    --     os.execute("python3 python/index.py")
                    --     return "success"
                    --     ]],
                    --     function(s, len)
                    --         print(ffi.string(s, len))
                    --     end
                    -- )
                    local url = "https://csgostash.com/" .. "weapon/" .. alias.alias[split[2]]
                    local item = split[3]
                    message.channel:send("Fetching....")
                    clib.start_thread(
                        [[
                            local curl = require "curl"
                            local Scraper = require "scraper"
                            local serpent = require "serpent"
                            local html_parser = require "htmlparser"

                            local http = curl:new(nil, url)

                            local html = ""

                            local scraper = Scraper:new()
                            
                            local function interp(s, tab)
                                return (s:gsub(
                                    "($%b{})",
                                    function(w)
                                        return tab[w:sub(3, -2)] or w
                                    end
                                ))
                            end
                            
                            getmetatable("").__mod = interp
                            
                            http.url = "${url}"

                        local function get_elements()
                            for c in http:get("curl ") do
                                html = html .. c
                            end
                         local root = html_parser.parse(html)

                         return root:select(".center-block")
                         end

                         local q = scraper.get_index(scraper, get_elements())
                        
                        --  local listing_url = q["${item}"].steam_info.item_url
                        --  local p_command = "echo " .. "'${listing_url}'" % {listing_url = listing_url}
                        --  p_command = p_command .. "> " .. " " .. "mypipe"
                        --  os.execute(p_command)

                        --  local f = io.open("./url.txt", "w")
                        --  f:write(q["${item}"].steam_info.item_url)
                        --  f:close()
                         return serpent.dump(q["${item}"])
                        ]] %
                            {url = url, item = item},
                        0,
                        function(s, len)
                            local str = ffi.string(s, len)
                            local q = nil
                            if str ~= "" then
                                q = load(str)()
                            end
                            if q ~= nil then
                                -- file = io.open("scrapedData.txt", "w")
                                -- file:write()
                                -- file:flush()
                                -- file:close()
                                print("inside")
                                clib.connect_to_domain_socket(
                                    "/tmp/socket",
                                    q.steam_info.item_url,
                                    function(s, len)
                                        q.listing = {listings = ffi.string(s, len)}
                                        send_embed(message.channel, q)
                                        coroutine.wrap(
                                            function()
                                                message.channel:send {
                                                    file = "element.png"
                                                }
                                            end
                                        )()
                                    end
                                )
                            else
                                coroutine.wrap(
                                    function()
                                        message.channel:send("`Item " .. item .. " " .. "not found`")
                                    end
                                )()
                            end
                        end
                    )
                end
            else
                if message.content:match("!alias") then
                    pcall(send_alias, message.channel)
                else
                    if message.content:match("!featured") then
                        http.url = "https://csgostash.com/"
                        local q = scraper.get_index(scraper, get_elements())
                        for i = 1, #scraper.names, 1 do
                            local name = scraper.names[i]
                            if name ~= nil then
                                send_embed(message.channel, q[name.name])
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
    end
)

client:run(token)
