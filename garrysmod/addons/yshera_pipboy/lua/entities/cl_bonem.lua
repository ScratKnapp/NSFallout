AddCSLuaFile()
print("FAKE bonem")
ENT.Type = "anim"
--ENT.RenderGroup = RENDERGROUP_OTHER
local materials = {}
local suffix = "sgaxxaxxx"
-- GET ENTITY METATTABLE 
local entMeta = FindMetaTable("Entity")
function entMeta:RenderParts()
    for i, v in pairs(self.parts or {}) do
        if IsValid(v) then v.RenderNow = true end
    end
end

function ENT:PrepareMaterial(mat, i)
    local shader = "VertexLitGeneric"
    local params = util.KeyValuesToTable(file.Read("materials/" .. mat .. ".vmt", "GAME")) or {}
    params.Proxies = params.proxies or {}
    print("parent", self.p)
    self.p = self:GetOwner()
    params["$cloakpassenabled"] = 1
    params["$cloakfactor"] = 1
    params.Proxies["PlayerCloak2"] = {}
    print(mat .. "-clxoaked")
    materials[mat] = CreateMaterial(mat .. suffix, shader, params)
    self:SetSubMaterial(i, mat .. suffix)
end

ENT.RenderGroup = 7
function ENT:SetNoDrawSafe(a)
    --self:SetNoDraw(a)
end

function ENT:Initialize()
    self.Materials = {}
    self:SetNoDrawSafe(false)
end

function ENT:Draw()
    if self.RenderNow then
        self:DrawModel()
        self.RenderNow = false
    end
    if self:GetParent() == nil then
        self:Remove()
    end 
    
    // not attached then remove
end

function ENT:RenderNextFrame()
    self.RenderNow = true
end

local plyDrawModel = false
local c = Material("color")
local debounce = false
hook.Add("PrePlayerDraw", "dont crash the game", function(ply)
    --for i, v in pairs(ply.parts or {}) do
    --    v.RenderNow = true
    --end
end)

hook.Add("PostPlayerDraw", "dont crash the game", function(ply)

    if !ply:GetNoDraw() then
        for i, v in pairs(ply.parts or {}) do
            v.RenderNow = true
        end
    end
end)
if CLIENT then
concommand.Add("PURGE_ALL", function()
    for i, v in ipairs(ents.GetAll()) do
        if v:GetClass() == "cl_bonem" then
            v:Remove()
        end
    end
end)
end
matproxy.Add{
    name = "PlayerCloak2",
    init = function() end,
    bind = function(self, mat, ent)
        --if not IsValid( ent ) or not ent.CloakFactor then return end 
        mat:SetFloat("$cloakfactor", 1)
    end
}