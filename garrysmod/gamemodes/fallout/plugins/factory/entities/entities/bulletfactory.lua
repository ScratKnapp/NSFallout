AddCSLuaFile()
ENT.PrintName = "Bullet Factory"
ENT.Type = "anim"
ENT.Author = "Barata"
ENT.Category = "Factories"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
ENT.itemspawned = "7.63×25mm"
ENT.timer = 1
ENT.model = "models/props_wasteland/kitchen_stove002a.mdl"
ENT.itemneeded = "iron_bar"
ENT.tool = "hammer"
ENT.sound = ""
ENT.ActionTimer = 25

function ENT:Initialize()
    if (SERVER) then
        self:SetModel(self.model or "models/props_c17/furnitureStove001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetNoDraw(false)
        self:SetNWInt("ACTIVATED", false)
        self:SetUseType(SIMPLE_USE)
        local physObj = self:GetPhysicsObject()
        physObj:EnableMotion(false)
    end
end

function ENT:Use(activator)
    local client = activator
    local data = self:GetNWInt("ACTIVATED", false)
    local position = self:GetPos() + Vector(0, 0, 32) -- change the last number if you need to change spawn heights

    if data == false and client:getChar():getInv():hasItem(self.tool) and client:getChar():getInv():hasItem(self.itemneeded) then
        client:setAction("Preparing Iron", self.ActionTimer, function()
            self:SetNWInt("ACTIVATED", true)
            activator:notify("You have activated the Factory!")
            self:EmitSound(self.sound, 75, 100, 1, CHAN_AUTO)

            timer.Simple(self.timer, function()
                nut.item.spawn(self.itemspawned, position)
                self:StopSound(self.sound)
                self:SetNWInt("ACTIVATED", false)
            end)
        end)
    end

    if data == true then
        activator:notify("This factory is on use!")
    end
end

function ENT:OnRemove()
    self:StopSound(self.sound)
end