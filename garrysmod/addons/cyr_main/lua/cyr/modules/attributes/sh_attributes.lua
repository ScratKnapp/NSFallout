-- CYR Attributes Module
-- Loads custom intelligence and charisma attributes

-- Wait for nutscript to be initialized before loading attributes
hook.Add("InitializedPlugins", "CYR_LoadAttributes", function()
    if nut and nut.attribs and nut.attribs.loadFromDir then
        nut.attribs.loadFromDir("cyr/modules/attributes")
        print("[CYR] Custom attributes (Intelligence, Charisma) loaded!")
    end
end)
