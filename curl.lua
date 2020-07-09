Http = {}

function Http:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Http:get(command, url)
    print(command .. url)
    local x = io.popen(command .. url)

    return x.lines(x)
end

return Http
