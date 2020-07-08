Scraper = {}

function Scraper:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
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
        for _, q in ipairs(t([[.quality]])) do
            local content = q:getcontent():match([[>(.*)<]]):match([[(.-)<]])
            if content ~= "" then
                name = content
            end
        end
    end
    return name
end

function Scraper:get_price(element)
    local p = {}
    local e = element(".price")

    p.price = e[1].nodes[1]:getcontent():match([[>(.*)<]])
    p.factory_price = e[2].nodes[1]:getcontent():match([[>(.*)<]])
    return p
end

function Scraper:get_steam_info(element)
    local e = element(".market-button-skin")
    local e2 = element(".inspect-button-skin")
    local e3 = element(".details-link")
    local url = e3[1].nodes[1].nodes[1].attributes.href

    return {inspect = e2[1].attributes.href, listings = e[1].attributes.href, item_url = url}
end

function Scraper:get_index(elements)
    local q = {}
    for i, e in ipairs(elements) do
        q[i] = {}
        q[i].src = e.attributes.src
        q[i].steam_info = self:get_steam_info(e.parent.parent)
        q[i].name = self:get_headers(e.parent.parent.nodes[1])
        q[i].price = self:get_price(e.parent.parent)

        local v = self:get_quality(e.parent.parent.nodes)
        if v ~= "" then
            q[i].quality = v
        end
    end
    return q
end

return Scraper
