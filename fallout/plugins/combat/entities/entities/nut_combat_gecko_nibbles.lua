ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Nibbles"
ENT.Category = "NutScript - Combat (Other)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Nibbles"

ENT.model = "models/fallout/gecko.mdl"
ENT.hp = 150
ENT.dmg = {
	["Slash"] = 30,
}
ENT.accuracy = 20
ENT.evasion = 20

function ENT:Initialize()
	self:basicSetup()
	
	timer.Simple(0.6, function()
		if(IsValid(self)) then
			self:SetModelScale(0.4)
		end
	end)
end

function ENT:Use(client)
	if((self.nextPet or 0) < CurTime()) then
		self.nextPet = CurTime() + 1.5
	
		nut.chat.send(client, "meclose", "pets Nibbles. He chirps happily.")
		nut.log.addRaw(client:Name() .. " has pet Nibbles.", 4)
	end
end

ENT.armor = {
	["Head"] = 0,
	["Body"] = 0,
	["Left Arm"] = 0,
	["Right Arm"] = 0,
	["Left Leg"] = 0,
	["Right Leg"] = 0,
}

--all attributes
ENT.attribs = {
	["str"] = 0,
	["per"] = 0,
	["end"] = 0,
	["cha"] = 0,
	["int"] = 0,
	["agi"] = 0,
	["luck"] = 0,

}

ENT.skills = {
	["evasion"] = 0,
}

ENT.res = {
}

ENT.actions = {
"charge",
"dodge",
"watergun",

}

ENT.tags = {
	["Biological"] = true,
	["Humanoid"] = true,
	["Living"] = true,
	["Authoriity"] = true,
}

function ENT:Initialize()
	self:basicSetup()
end