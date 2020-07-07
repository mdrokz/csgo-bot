Http = {url = ''}

function Http:new(o,url)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    self.url = url
    return o
end

function Http:change_url(url)
    self.url = url
end

function Http:get(command)
    print(command .. self.url)
    local x = io.popen(command .. self.url)

    return x.lines(x)
end

return Http