Scraper = {names = {}}
local pprint = require "pprint"

function Scraper:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.names = {}
    return o
end

function Scraper:get_headers(element)
    local skin_name = ""
    if element.nodes[2] ~= nil then
        skin_name = "|" .. element.nodes[2]:getcontent()
    end
    local content = element.nodes[1]:getcontent() .. skin_name
    if content ~= "" then
        return content
    end
end

function Scraper:get_quality(element)
    local name = ""
    for _, t in ipairs(element) do
        -- pprint(t.parent.parent.nodes[1].name)
        local quality = t.parent.parent([[.quality]])
        name = quality[1]:getcontent():match([[>(.*)<]]):match([[(.-)<]])
    end
    return name
end

function Scraper:get_price(element)
    local p = {}
    local e = element(".price")

    if e[1] ~= nil and e[2] ~= nil then
        p.price = e[1].nodes[1]:getcontent():match([[>(.*)<]])
        p.factory_price = e[2].nodes[1]:getcontent():match([[>(.*)<]])
        return p
    end
end

function Scraper:get_steam_info(element)
    local e = element(".market-button-skin")
    local e2 = element(".inspect-button-skin")
    local e3 = element(".details-link")
    local url = e3[1].nodes[1].nodes[1].attributes.href

    if e2[1] ~= nil and e[1] ~= nil then
        return {inspect = e2[1].attributes.href, listings = e[1].attributes.href, item_url = url}
    end
end

function Scraper:get_index(elements, clib)
    local q = {}
    for i, e in ipairs(elements) do
        local name = self:get_headers(e.parent.parent.nodes[1])
        if name ~= nil then
            self.names[i] = {name = name}
            q[name] = {}
            q[name].src = e.attributes.src
            q[name].steam_info = self:get_steam_info(e.parent.parent)
            q[name].name = name
            q[name].price = self:get_price(e.parent.parent)

            local v = self:get_quality(elements)
            if v ~= "" then
                q[name].quality = v
            end
        end
    end
    return q
end

return Scraper
