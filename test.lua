local x = "<p>hello world<p>"

local y = "Mil-Spec Pistol<span class=rarity-search-icon><span class=glyphicon glyphicon-search></span></span>"

print(y:match("^.*?(<)"))
print(y:match("(.-)<"))

print(x:match(">(.*)<"))