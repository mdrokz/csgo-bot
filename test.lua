-- local thread = require("thread")
local pprint = require("pprint")
-- local timer = require "timer"
local fs = require "fs"
local ffi = require "ffi"

-- local interval =
--   timer.setInterval(
--   1000,
--   function()
--     print("Main Thread", thread.self(), os.date())
--   end
-- )

-- print("Main ...running...")

-- function entry(cli)
--   local timer = require "timer"
--   local thread = require "thread"
--   local interval =
--     timer.setInterval(
--     1000,
--     function()
--       print(cli, thread.self(), os.date())
--     end
--   )
-- end

-- thread.start(entry, "cli1")
-- thread.start(entry, "cli2")
-- thread.start(entry, "cli3")

-- local x = "<p>hello world<p>"

-- local y = "Mil-Spec Pistol<span class=rarity-search-icon><span class=glyphicon glyphicon-search></span></span>"

-- print(y:match("^.*?(<)"))
-- print(y:match("(.-)<"))

-- print(x:match(">(.*)<"))

-- local f = io.open("scrapedData.txt", "w")

-- print(f:write())

local clib = ffi.load("threading/target/release/librust_threading.so")

ffi.cdef [[
  typedef void (*cb)(const char* v);
  void start_thread(const char* v, void (*)(const char* v,int len));
  void spawn_process(const char* process,const char* args);
]]

pprint(ffi)

function interp(s, tab)
  return (s:gsub(
    "($%b{})",
    function(w)
      return tab[w:sub(3, -2)] or w
    end
  ))
end

getmetatable("").__mod = interp

local url = "https://csgostash.com"

local code = [[
        local url = ${url}
]] % {url = url}

pprint(code)

-- clib.start_thread(
--   [[
--     local scraper = require "scraper"
--     local serpent = require "serpent"

--     local s = scraper:new(nil)

--     local t = {d = 20,memes = "d wa", d = {t = 1}}

--     return serpent.dump(t)
--   ]],
--   function(s, len)
--     local t = ffi.string(s, len)
--     pprint(t, load(t)())
--   end
-- )

print("after hello")

-- clib.spawn_process("python3", "python/index.py")
-- os.execute("echo 'https://csgostash.com/skin/262/CZ75-Auto-Victoria' > mypipe")

-- local f = io.open("scrapedData.txt","r+")

-- print(f:read(400))
-- f:write("")
-- local f = io.popen("tail -f scrapedData.txt")
-- clib.spawn_process("tail", "-f scrapedData.txt")

-- fs.stat(
--   "scrapedData.txt",
--   function(err, stat)
--     pprint(stat.size)
--   end
-- )

local l = true
local f = io.open("scrapedData.txt", "r+")

f:seek("set", 10)
print(f:write("l"))
-- while l do
--   -- local f = io.open("scrapedData.txt","r")
--   -- local data = f:read()
--   if f:read() ~= nil then
--     f:close()
--     l = false
--     print("file check ended")
--     break
--   end
-- end

-- local f = io.read(300)

-- print("HELLO WORLD" + f)

print("python process done")
