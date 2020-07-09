local thread = require("thread")
local pprint = require("pprint")
local timer = require "timer"
local thread = require "thread"
local serpent = require "serpent"
local uv = require("uv")

-- local interval =
--     timer.setInterval(
--     1000,
--     function()
--         print("Main Thread", thread.self(), os.date())
--     end
-- )

-- print("Main ...running...")

function entry(cli)
    local timer = require "timer"
    local thread = require "thread"
    local interval =
        timer.setInterval(
        1000,
        function()
            print(cli, thread.self(), os.date())
        end
    )
end

-- v = thread.start(entry, "cli1")
-- v2 = thread.start(entry, "cli2")
-- v3 = thread.start(entry, "cli3")

-- thread.join(v,v2,v3)
t = 1000
tt = {boom = true}
-- s =
--     thread.work(
--     function(a, b)
--         print(a, b)
--         return {dos = 2}
--     end,
--     function(arg1, arg2, arg3)
--         print("test")
--         tt.boom = false
--     end
-- )

-- local y = thread.join(s)

-- s:queue(2, 3)

p = 100

e, v12 =
    thread.start(
    function(arg)
        arg = 30
        return arg
    end,
    p
)

pprint(v12)

v4 = e:join()

pprint(v12)
pprint(e.userdata)

print(p)

local function test()
end

-- local s = string.dump(test)

async =
    uv.new_work(
    function(c)
        local pprint = require "pprint"
        -- pprint(c)
        local f = load(c, "t")
        -- pprint(f())
        return 5
    end,
    function(t)
        -- print(t)
    end
)

t = {
    {11, 12, 13},
    {21, 20, 23}
}

for _,v in pairs(t) do
    pprint(v)
end

local s = {"return {"}
for i = 1, #t do
    print(#t[i])
    s[#s + 1] = "{"
    for j = 1, #t[i] do
        s[#s + 1] = t[i][j]
        s[#s + 1] = ","
    end
    s[#s + 1] = "},"
end
s[#s + 1] = "}"
s = table.concat(s)

async:queue(s)

print(serpent.dump(t))

-- print(s)

local x = "<p>hello world<p>"

local y = "Mil-Spec Pistol<span class=rarity-search-icon><span class=glyphicon glyphicon-search></span></span>"

-- print(y:match("^.*?(<)"))
-- print(y:match("(.-)<"))

-- print(x:match(">(.*)<"))

-- print(tt.boom)
-- timer.setInterval(
--     1000,
--     function()
--         print(tt.boom)
--     end
-- )
