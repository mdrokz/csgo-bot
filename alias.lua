local alias = {
    -- pistols
    cz = "CZ75-Auto",
    deagle = "Desert+Eagle",
    dualb = "Dual+Berettas",
    fiveseven = "Five-SeveN",
    glock = "Glock-18",
    p2000 = "P2000",
    p250 = "P250",
    revolver = "R8+Revolver",
    tec9 = "Tec-9",
    usp = "USP-S",
    -- rifles
    ak47 = "AK-47",
    aug = "AUG",
    awp = "AWP",
    famas = "FAMAS",
    g3sg = "G3SG1",
    galil = "Galil+AR",
    m4s = "M4A1-S",
    m4 = "M4A4",
    scar = "SCAR-20",
    sg = "SG+553",
    scout = "SSG+08",
    -- smg
    mac10 = "MAC-10",
    mp5 = "MP5-SD",
    mp7 = "MP7",
    mp9 = "MP9",
    ppbizon = "PP-Bizon",
    p90 = "P90",
    ump = "UMP-45",
    -- heavy
    mag7 = "MAG-7",
    nova = "Nova",
    sawedoff = "Sawed-Off",
    xm1014 = "XM1014",
    m249 = "M249",
    negev = "Negev",
    -- knives
    nomad = "Nomad+Knife",
    skeleton = "Skeleton+Knife",
    survival = "Survival+Knife",
    paracord = "Paracord+Knife",
    classic = "Classic+Knife",
    bayonet = "Bayonet",
    bowie = "Bowie+Knife",
    butterfly = "Butterfly+Knife",
    falchion = "Falchion+Knife",
    flip = "Flip+Knife",
    gut = "Gut+Knife",
    huntsman = "Huntsman+Knife",
    karambit = "Karambit",
    m9bayonet = "M9+Bayonet",
    navaja = "Navaja+Knife",
    shadow = "Shadow+Daggers",
    stiletto = "Stiletto+Knife",
    talon = "Talon+Knife",
    ursus = "Ursus+Knife"
}

local knives = {
    [[nomad]],
    [[skeleton]],
    [[survival]],
    [[paracord]],
    [[classic]],
    [[bayonet]],
    [[bowie]],
    [[butterfly]],
    [[falchion]],
    [[flip]],
    [[gut]],
    [[huntsman]],
    [[karambit]],
    [[m9bayonet]],
    [[navaja]],
    [[shadow]],
    [[stiletto]],
    [[talon]],
    [[ursus]]
}

local pistol = {
    [[cz]],
    [[deagle]],
    [[dualb]],
    [[fiveseven]],
    [[glock]],
    [[p2000]],
    [[p250]],
    [[revolver]],
    [[tec9]],
    [[usp]]
}

local rifles = {
    [[ak47]],
    [[aug]],
    [[awp]],
    [[famas]],
    [[g3sg]],
    [[galil]],
    [[m4s]],
    [[m4]],
    [[scar]],
    [[sg]],
    [[scout]]
}

local smg = {
    [[mac10]],
    [[mp5]],
    [[mp7]],
    [[mp9]],
    [[ppbizon]],
    [[p90]],
    [[ump]]
}

local heavy = {
    [[mag7]],
    [[nova]],
    [[sawedoff]],
    [[xm1014]],
    [[m249]],
    [[negev]]
}

return {
    alias = alias,
    knives = knives,
    pistol = pistol,
    heavy = heavy,
    smg = smg,
    rifles = rifles
}
