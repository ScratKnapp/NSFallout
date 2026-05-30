-- 2026 Evi // CYR Framework - Combat Model / Limb Definitions
--
-- Lets you describe per-model limb layouts for the combat targetting system:
--   * which limbs an entity has (omit limbs robots/aliens don't have)
--   * which bones make up each limb (used for aim point / hitbox queries)
--   * pseudo-limbs ("Back Left Leg" for quadrupeds, "Tail", "Antenna", ...)
--   * multiple models sharing the same limb set via helper functions
--
-- Usage:
--   NWL.CombatModel.RegisterLimbSet("human", { ... })
--   NWL.CombatModel.AssignModel({"models/foo.mdl","models/bar.mdl"}, "human")
--   NWL.CombatModel.DeriveLimbSet("robot_nolegs", "human", { omit = {"Left Leg","Right Leg"} })
--   NWL.CombatModel.DeriveLimbSet("dog", "human", {
--       omit = {"Left Arm","Right Arm","Left Leg","Right Leg"},
--       add  = {
--           ["Front Left Leg"]  = { bones = {"ValveBiped.Bip01_L_UpperArm"} },
--           ["Front Right Leg"] = { bones = {"ValveBiped.Bip01_R_UpperArm"} },
--           ["Back Left Leg"]   = { bones = {"ValveBiped.Bip01_L_Thigh"} },
--           ["Back Right Leg"]  = { bones = {"ValveBiped.Bip01_R_Thigh"} },
--           ["Tail"]            = { bones = {"ValveBiped.Bip01_Tail1"} },
--       },
--   })

NWL = NWL or {}
NWL.CombatModel = NWL.CombatModel or {}

local CM = NWL.CombatModel
CM.Sets    = CM.Sets    or {} -- [setID] = { [limbName] = { bones = {...}, accuracyMult, dmg, ... } }
CM.Models  = CM.Models  or {} -- [lowered modelPath] = setID
CM.Default = CM.Default or nil -- fallback setID applied when a model has no explicit assignment

local function normModel(mdl)
    return string.lower(string.gsub(tostring(mdl or ""), "\\", "/"))
end

local function copyLimbs(src)
    local out = {}
    for name, data in pairs(src or {}) do
        local copy = {}
        for k, v in pairs(data) do copy[k] = v end
        if data.bones then
            copy.bones = {}
            for i = 1, #data.bones do copy.bones[i] = data.bones[i] end
        end
        out[name] = copy
    end
    return out
end

-- Register a brand-new limb set.
-- limbs: { [name] = { bones = {"bone1", ...}, accuracyMult = ?, dmg = ? } }
function CM.RegisterLimbSet(id, limbs)
    assert(isstring(id), "CombatModel: set id must be a string")
    CM.Sets[id] = copyLimbs(limbs)
    return CM.Sets[id]
end

-- Create a new set from an existing one. opts = { omit = {...}, add = {...}, override = {...} }
function CM.DeriveLimbSet(newID, baseID, opts)
    local base = CM.Sets[baseID]
    assert(base, "CombatModel: unknown base set '" .. tostring(baseID) .. "'")
    opts = opts or {}

    local set = copyLimbs(base)

    if opts.omit then
        for _, name in ipairs(opts.omit) do set[name] = nil end
    end
    if opts.override then
        for name, data in pairs(opts.override) do
            if set[name] then
                for k, v in pairs(data) do set[name][k] = v end
            end
        end
    end
    if opts.add then
        for name, data in pairs(opts.add) do
            local copy = {}
            for k, v in pairs(data) do copy[k] = v end
            set[name] = copy
        end
    end

    CM.Sets[newID] = set
    return set
end

-- Bind one or more models to a registered set.
function CM.AssignModel(modelOrList, setID)
    assert(CM.Sets[setID], "CombatModel: cannot assign unknown set '" .. tostring(setID) .. "'")
    if istable(modelOrList) then
        for _, m in ipairs(modelOrList) do CM.Models[normModel(m)] = setID end
    else
        CM.Models[normModel(modelOrList)] = setID
    end
end

-- Convenience: declare an inline set and assign it to one or many models in one call.
function CM.RegisterModel(modelOrList, setID, limbs)
    if limbs then CM.RegisterLimbSet(setID, limbs) end
    CM.AssignModel(modelOrList, setID)
end

-- Fallback used when an entity's model has no explicit set.
function CM.SetDefault(setID)
    assert(setID == nil or CM.Sets[setID], "CombatModel: unknown default set '" .. tostring(setID) .. "'")
    CM.Default = setID
end

local function resolveSetID(target)
    if isstring(target) then
        return CM.Models[normModel(target)] or CM.Default
    elseif IsValid(target) then
        return CM.Models[normModel(target:GetModel())] or CM.Default
    end
end

-- Returns the limb table { [name] = data } for an entity or a raw model path. May be nil.
function CM.GetLimbSet(target)
    local id = resolveSetID(target)
    return id and CM.Sets[id] or nil, id
end

-- Returns the limb data for one named limb, or nil if this entity doesn't have that limb.
function CM.GetLimb(target, limbName)
    local set = CM.GetLimbSet(target)
    return set and set[limbName] or nil
end

-- True if this entity has the named limb (used to gate robot legs etc.).
function CM.HasLimb(target, limbName)
    return CM.GetLimb(target, limbName) ~= nil
end

-- List of limb names available on this entity (stable alphabetical order).
function CM.GetLimbNames(target)
    local set = CM.GetLimbSet(target)
    if not set then return {} end
    local out = {}
    for name in pairs(set) do out[#out + 1] = name end
    table.sort(out)
    return out
end

-- World-space aim position for a limb. Averages all of the limb's bones that resolve.
-- Falls back to the entity's WorldSpaceCenter() if no bones resolve.
function CM.GetLimbPos(ent, limbName)
    if not IsValid(ent) then return end
    local limb = CM.GetLimb(ent, limbName)
    if not limb or not limb.bones then
        return ent:WorldSpaceCenter()
    end

    if ent.SetupBones then ent:SetupBones() end

    local sum, count = Vector(0, 0, 0), 0
    for _, boneName in ipairs(limb.bones) do
        local idx = ent:LookupBone(boneName)
        if idx then
            local pos = ent:GetBonePosition(idx)
            -- GetBonePosition can return the entity origin for some bones; use matrix as backup.
            if pos and pos ~= ent:GetPos() then
                sum = sum + pos
                count = count + 1
            else
                local m = ent:GetBoneMatrix(idx)
                if m then
                    sum = sum + m:GetTranslation()
                    count = count + 1
                end
            end
        end
    end

    if count == 0 then return ent:WorldSpaceCenter() end
    return sum / count
end

-- Dev helper: dump every bone on a model to console so it can be wired into a limb set.
-- Usage:
--   cyr_listbones                       -> uses the entity you're looking at
--   cyr_listbones models/foo/bar.mdl    -> spawns a hidden temp entity and reads its bones
if CLIENT then
    CM.BoneBuffer = CM.BoneBuffer or ""

    local function append(line)
        CM.BoneBuffer = CM.BoneBuffer .. line .. "\n"
    end

    local function printBones(ent, label)
        if not IsValid(ent) then return end
        ent:SetupBones()
        local count = ent:GetBoneCount() or 0
        local header = "[CombatModel] " .. label .. " (" .. count .. " bones)"
        MsgC(Color(120, 200, 255), header .. "\n")
        append(header)
        for i = 0, count - 1 do
            local name = ent:GetBoneName(i) or "?"
            local parent = ent:GetBoneParent(i)
            local parentName = parent and parent >= 0 and ent:GetBoneName(parent) or "-"
            local line = string.format("  [%3d] %-40s parent=%s", i, name, parentName)
            MsgC(Color(220, 220, 220), line .. "\n")
            append(line)
        end
    end

    concommand.Add("cyr_listbones", function(ply, _, args)
        local model = args[1]
        if model and model ~= "" then
            local ent = ClientsideModel(model, RENDERGROUP_OPAQUE)
            if not IsValid(ent) then
                MsgC(Color(255, 100, 100), "[CombatModel] Failed to create clientside model for '" .. model .. "'\n")
                return
            end
            ent:SetNoDraw(true)
            ent:SetPos(Vector(0, 0, -16384))
            printBones(ent, model)
            ent:Remove()
        else
            local tr = LocalPlayer():GetEyeTrace()
            local ent = tr.Entity
            if not IsValid(ent) then
                MsgC(Color(255, 100, 100), "[CombatModel] No entity under crosshair. Pass a model path or aim at something.\n")
                return
            end
            printBones(ent, ent:GetModel() or tostring(ent))
        end
    end, nil, "List bones of a model. Usage: cyr_listbones [models/path.mdl] (omit to use the entity under your crosshair)")

    concommand.Add("cyr_bone_copy", function()
        if CM.BoneBuffer == "" then
            MsgC(Color(255, 180, 80), "[CombatModel] Bone buffer is empty - run cyr_listbones first.\n")
            return
        end
        SetClipboardText(CM.BoneBuffer)
        MsgC(Color(120, 255, 120), "[CombatModel] Copied " .. #CM.BoneBuffer .. " chars to clipboard.\n")
    end, nil, "Copy the accumulated cyr_listbones output to clipboard.")

    concommand.Add("cyr_bone_reset", function()
        CM.BoneBuffer = ""
        MsgC(Color(120, 200, 255), "[CombatModel] Bone buffer cleared.\n")
    end, nil, "Clear the accumulated cyr_listbones buffer.") 
  print("added bone_reset")
end

-- Helper for combat code: pick whichever limb of a candidate list actually exists on this ent.
-- Useful when a hit lands on a generic group ("Leg") and you need to pick the closest pseudo-limb.
function CM.PickAvailable(target, candidates)
    for _, name in ipairs(candidates) do
        if CM.HasLimb(target, name) then return name end
    end
end


