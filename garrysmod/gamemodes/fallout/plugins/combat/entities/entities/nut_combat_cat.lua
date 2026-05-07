ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Cat"
ENT.Category = "NutScript - Combat (Other)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.noRag = true
ENT.espIgnore = true

ENT.model = "models/jeezy/animals/siamese_cat/siamese_cat.mdl"
ENT.hp = 10
ENT.dmg = {
	["Slash"] = 5,
}
ENT.accuracy = 10
ENT.evasion = 10

--all attributes
ENT.attribs = {
	["agi"] = 100,
}

ENT.tags = {
	["Animal"] = true,
	["Cat"] = true,
	["Living"] = true,
}

function ENT:Initialize()
	self:basicSetup()
	
	timer.Simple(0.6, function()
		if(IsValid(self)) then
			self:SetSkin(math.random(0,8))
			self:SetModelScale(0.5)
		end
	end)
end

function ENT:Use(client)
	if((self.nextPet or 0) < CurTime()) then
		self.nextPet = CurTime() + 1.5
	
		nut.chat.send(client, "meclose", "pets the cat. It seems to appreciate the attention.")
		nut.log.addRaw(client:Name() .. " has pet a cat.", 4)
	end
end

ENT.chatStrings = {
	"Meow.",
	"Meow.",
	"Meow.",
	"Meow.",
	"Meow.",
	"Meow.",
	"Meow.",
	"Meow?",
	"Meow!",
	"Nyan.",
}

function ENT:CustomThink()
	if(SERVER) then
		if(!self.nextSay) then self.nextSay = CurTime() + 10 end
		
		if(self.nextSay < CurTime()) then
			nut.chat.send(self, "say_npc", (self.name or self.PrintName).. " whispers, \"" ..table.Random(self.chatStrings).."\"")
			
			self.nextSay = CurTime() + math.random(600, 1200)
		end
	end
end