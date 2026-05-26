-- Compat shim: bridges yshera_pipboy's expected NutScript surface
-- (older skills-as-perks layout) onto gamemodes/fallout's APIs:
-- skills plugin, attributes plugin, traits-as-perks, level plugin point pools.

if SERVER then
    AddCSLuaFile()
end

PIPBOY_SHOW_BODY_HP = false

local POOL_KEYS = {
    level          = "level",   -- read-only mirror
    skillpoints    = "ptSkill",
    specialpoints  = "ptAttrib",
    perkpoints     = "ptPerk",
}

local SPECIAL_KEYS = {
    str = true, per = true, ["end"] = true,
    cha = true, int = true, agi = true, luck = true,
    -- alias the pipboy's 3-letter "luc" so any stale callers still work.
    luc = "luck",
}

local function resolveSpecial(k)
    local m = SPECIAL_KEYS[k]
    return m == true and k or m
end

local function isComputedSkill(k)
    return POOL_KEYS[k] ~= nil
end

local function installCharMeta()
    if not nut or not nut.meta or not nut.meta.character then return end
    local CHAR = nut.meta.character

    -- Older pipboy API: getSkillLevel/setSkillLevel/addSkillLevel.
    -- Maps to :getSkill / :setSkill / :updateSkill for real skills, and to
    -- character data fields for the "skillpoints" / "perkpoints" / "specialpoints"
    -- / "level" pseudo-skills used by the pipboy progression UI.
    if not CHAR.getSkillLevel then
        function CHAR:getSkillLevel(key, default)
            local pool = POOL_KEYS[key]
            if pool then
                return self:getData(pool, key == "level" and 1 or 0)
            end
            if SPECIAL_KEYS[key] then
                return self:getAttrib(resolveSpecial(key), default or 0)
            end
            return self:getSkill(key, default or 0, true)
        end
    end

    if not CHAR.setSkillLevel then
        function CHAR:setSkillLevel(key, value)
            local pool = POOL_KEYS[key]
            if pool then
                self:setData(pool, value)
                return
            end
            if self.setSkill then self:setSkill(key, value, true) end
        end
    end

    if not CHAR.addSkillLevel then
        function CHAR:addSkillLevel(key, delta)
            local pool = POOL_KEYS[key]
            if pool then
                self:setData(pool, (self:getData(pool, 0) or 0) + (delta or 0))
                return
            end
            if self.updateSkill then self:updateSkill(key, delta or 0) end
        end
    end

    -- The pipboy STATS footer reads an XP bar from getSkillXP / getSkillXPForLevel
    -- and only ever passes "level". Route to the level plugin's storage.
    if not CHAR.getSkillXP then
        function CHAR:getSkillXP(key)
            if key == "level" or key == nil then
                return self:getData("xp", 0)
            end
            return 0
        end
    end

    if not CHAR.getSkillXPForLevel then
        function CHAR:getSkillXPForLevel(key)
            local lvl = self:getData("level", 1)
            local maxLevel = nut.config.get("maxLevel", 16)
            if lvl >= maxLevel then return math.huge end
            return lvl * 60
        end
    end

    -- pipboy:isPerkOwned(i) -- maps the synthetic PERKS[i] index to a real trait uid
    if not CHAR.isPerkOwned then
        function CHAR:isPerkOwned(i)
            local perk = PERKS and PERKS[i]
            if not perk then return false end
            local ply = self:getPlayer()
            if not IsValid(ply) or not ply.hasTrait then return false end
            return ply:hasTrait(perk.uid) == true
        end
    end

    -- Vestigial "starting trait" int the pipboy still references. Not connected
    -- to the gamemode trait system; kept so any reads don't blow up.
    if not CHAR.getTrait then
        function CHAR:getTrait() return self:getData("_trait", 0) end
    end
    if not CHAR.setTrait then
        function CHAR:setTrait(n) self:setData("_trait", n or 0) end
    end

    -- Some screens read appearance settings (pipboy worn flag, etc.).
    if not CHAR.getApperance then
        function CHAR:getApperance()
            local app = self:getData("appearance")
            if type(app) ~= "table" then app = {} end
            return app
        end
    end
end

-- Radiation stub. Real radiation never made it into this gamemode; pipboy reads
-- this in a couple of HUD spots. Return 0 so the rad bar self-hides (it's gated
-- on > 0 in the modified cl_stats).
local PLAYER = FindMetaTable("Player")
if PLAYER and not PLAYER.GetRads then
    function PLAYER:GetRads() return 0 end
end

if PLAYER and not PLAYER.getLocalVar then
    -- old NutScript called this getLocalVar; getNetVar is the modern name.
    function PLAYER:getLocalVar(key, default)
        if self.getNetVar then return self:getNetVar(key, default) end
        return default
    end
end

-- CheckSkill({skillKey, threshold}, ply): perk-requirement helper.
-- Accepts SPECIAL one-letter codes (S/P/E/C/I/A/L), "level", or any real skill key.
if CheckSkill == nil then
    local LETTER_TO_ATTR = {
        S = "str", P = "per", E = "end", C = "cha",
        I = "int", A = "agi", L = "luck",
    }

    function CheckSkill(req, ply)
        ply = ply or LocalPlayer()
        if not IsValid(ply) then return false end
        local char = ply:getChar()
        if not char then return false end
        local key, threshold = req[1], tonumber(req[2]) or 0

        if key == "level" then
            return (char:getData("level", 1) or 1) >= threshold
        end

        local attrKey = LETTER_TO_ATTR[key] or (SPECIAL_KEYS[key] and resolveSpecial(key))
        if attrKey then
            return (char:getAttrib(attrKey, 0) or 0) >= threshold
        end

        return (char:getSkill(key, 0) or 0) >= threshold
    end
end

-- Build PERKS from TRAITS on first plugin init. The pipboy's perks UI iterates
-- this table by integer index; we keep the uid in each entry so the unlock
-- netstream can send the real trait uid to the level plugin's "perkAdd" hook.
PERKS = PERKS or {}
local function buildPerks()
    if not TRAITS or not TRAITS.traits then return end
    table.Empty(PERKS)
    local i = 0
    for uid, t in SortedPairs(TRAITS.traits) do
        i = i + 1
        local entry = {
            uid = uid,
            id = uid,
            display = t.name or uid,
            desc = t.desc or "",
            material = t.material or Material("vgui/avatar_default"),
            requirements = t.requirements or {},
            onLevel = t.onLevel,
        }
        print("mat ", entry.material)

        PERKS[i] = entry
    end
end
buildPerks()
-- Stub: pipboy repair UI iterates a REPAIR_GROUP. Returns an empty group so the
-- screen renders without erroring; gamemode handles real durability elsewhere.
REPAIR_GROUP = REPAIR_GROUP or {}
function REPAIR_GROUP:Get(_)
    return {REPAIR_VALUE = {}}
end

hook.Add("InitializedPlugins", "yshera_pipboy_compat", function()
    installCharMeta()
    buildPerks()
end)

-- The autoloader includes our autorun files before the gamemode finishes
-- bootstrapping plugins, so if nut.meta.character is already there at this
-- point (lua refresh), install immediately too.
if nut and nut.meta and nut.meta.character then
    installCharMeta()
    buildPerks()
end
