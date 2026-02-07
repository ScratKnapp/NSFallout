ENT.Type = "nextbot"
ENT.Base = "nut_combat"
ENT.PrintName = "Nerixo Cat"
ENT.Category = "NutScript - Combat (Other)"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name = "Unhealthy Cat"

ENT.noRag = true
ENT.espIgnore = true

ENT.model = "models/jeezy/animals/siamese_cat/siamese_cat.mdl"
ENT.hp = 10
ENT.dmg = {
	["Slash"] = 2,
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
	
		nut.chat.send(client, "meclose", "pets the cat. That was a bad idea.")
		nut.log.addRaw(client:Name() .. " has pet a cat.", 4)

		local char = client:getChar()
		local charID = char:getID()
	
		local dur = 1200
		local catBoost = {
			["cool"] = -1,
		}

		for k, v in pairs(catBoost) do
			buffAmt = v
			
			char:addBoost("catbuff", k, buffAmt)
		end	
		
		if(timer.Exists("CatEffect" ..client:EntIndex())) then 
			timer.Adjust("CatEffect" ..client:EntIndex(), dur, 1, function()

				if (client and IsValid(client)) then
					local curChar = client:getChar()
					if (curChar and curChar:getID() == charID) then
						client:notify("Cat has worn off.")

						if (catBoost) then
							for k, v in pairs(catBoost) do
								char:removeBoost("catbuff", k)
							end
						end
					end
				end
			end)
		else				
			timer.Create("CatEffect" ..client:EntIndex(), dur, 1, function()
				if (client and IsValid(client)) then
					local curChar = client:getChar()
					if (curChar and curChar:getID() == charID) then
						client:notify("Cat has worn off.")

						if (catBoost) then
							for k, v in pairs(catBoost) do
								char:removeBoost("catbuff", k)
							end
						end
					end
				end
			end)
		end
		
		client:giveDisease("dis_cold")
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
	"I have seen the terrible things that you have done.",
	"You will die in a house fire.",
	"Life is an endless abyss with no purpose. We are all born to slave away for nothing and then die in complete agony forever.",
	"What is life, if not just death pending?",
	"fat.",
}

function ENT:CustomThink()
	if(SERVER) then
		if(!self.nextSay) then self.nextSay = CurTime() + 10 end
		
		if(self.nextSay < CurTime()) then
			nut.chat.send(self, "say_npc", self.name or self.PrintName .. " whispers, \"" ..table.Random(self.chatStrings).."\"")
			
			self.nextSay = CurTime() + math.random(600, 1200)
		end
	end
end