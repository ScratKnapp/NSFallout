local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Supplier"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Nutscript - Suppliers"
ENT.AutomaticFrameAdvance = true

ENT.supplier = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.cd = 7
ENT.cost = 3000

ENT.models = {
	"models/player/group01/male_02.mdl"
}

if (SERVER) then
	function ENT:Initialize()
		local model = self:getNetVar("model", self.models[math.random(#self.models)])
		self:SetModel(model)

		local material = self:getNetVar("material", "")
		self:SetMaterial(material)

		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		
		local pos = self:GetPos()
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:EnableGravity(false)
			--physObj:Sleep()
			physObj:EnableCollisions(false)
		end
		
		for k, v in ipairs(self:GetSequenceList()) do
			if (v:lower():find("idle") and v != "idlenoise") then
				self:ResetSequence(k)
				break
			end
		end
	end
	
	function ENT:getSaveData()
		local saveData = {
			name = self:getNetVar("name", self.PrintName),
			shipmentName = self:GetShipmentName() or "",
			model = self:GetModel() or "",
			material = self:GetMaterial() or "",
			cost = self:GetCost() or "",
			cd = self:GetCD() or "",
			players = self:GetCDTbl() or {},
			trait = self:GetTrait() or "",
			shipment = self:GetShipment(),
			random = self:GetRandom(),
			randomAmt = self:GetRandomAmt(),
			
			dayTracker = self:getNetVar("dayTracker", os.date("%j"))
		}
		
		return saveData
	end
	
	--decrements cooldown by one day if necessary
	function ENT:onLoaded()
		local day = os.date("%j")
		
		if(day != self:getNetVar("dayTracker", os.date("%j"))) then
			self:setNetVar("dayTracker", day)
			
			local CDTbl = self:GetCDTbl()
			for k, v in pairs(CDTbl) do
				if(v > 1) then
					CDTbl[k] = v-1
				else
					CDTbl[k] = nil
				end
			end
			
			self:setNetVar("players", CDTbl)
		end
	end
	
	function ENT:AddCD(client)
		local char = client:getChar()
		local cdTbl = self:GetCDTbl()
		
		cdTbl[char:getID()] = self:GetCD()
		
		self:setNetVar("players", cdTbl)
		
		PLUGIN:SaveData()
	end
	
	--finds trait from a partial string or id
	local function traitFromName(name)
		local traits = TRAITS.traits
		
		if(traits[name]) then
			return name
		end
		
		local name = string.lower(name)
		
		local trait
		for k, v in pairs(traits) do
			if(string.lower(v.name) == string.lower(name)) then --exact name
				trait = k
				break	
			elseif(string.find(string.lower(v.name), string.lower(name))) then --partial name
				trait = k
			end
		end
		
		return trait
	end
	
	function ENT:Use(client)
		local traitName = self:GetTrait()
		
		if(traitName) then
			local trait = traitFromName(traitName)
			if(trait and client:hasTrait(trait)) then
				--they have the trait yay
			else
				client:notify("You do not have the right trait.")
				return false
			end
		end
	
		local message = "Do you want to order from this supplier?"
		message = message.. "\nIt will cost " ..nut.currency.get(self:GetCost()).. "."
		message = message.. "\nIt will be unavailable for " ..self:GetCD().. " days."
	
		client:requestQuery(message, "Confirmation", function()
			local char = client:getChar()
			
			local cdTbl = self:GetCDTbl()
			if(cdTbl[char:getID()]) then
				client:notify("You cannot do this for " ..cdTbl[char:getID()].. " more days.")
				return false
			end
			
			if(char:getMoney() < self:GetCost()) then
				client:notify("You do not have enough money.")
				return false
			end
			
			char:takeMoney(self:GetCost())
			self:AddCD(client)
			
			local items = table.Copy(self:GetShipment())
			
			if(self:GetRandom()) then
				local randomAmt = self:GetRandomAmt()
			
				ranItems = {}
			
				for i = 1, randomAmt do
					local itemAmount, itemName = table.Random(items)
					
					if(!ranItems[itemName]) then
						ranItems[itemName] = itemAmount
					else
						ranItems[itemName] = ranItems[itemName] + itemAmount
					end
				end
				
				items = ranItems
			end
			
			local entity = ents.Create("nut_shipment2")
			entity:SetPos(client:getItemDropPos())
			entity:Spawn()
			entity:setItems(items)
			entity:setNetVar("owner", client:getChar():getID())
			entity:setNetVar("displayText", self:GetShipmentName())
		end)
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	ENT.DrawEntityInfo = true
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y
		
		local name = self:GetName()
		local tx, ty = drawText(name, x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
	end
end

function ENT:GetName()
	local name = self:getNetVar("name", self.PrintName)
	
	return name
end

function ENT:GetShipmentName()
	local name = self:getNetVar("shipmentName", "Shipment")
	
	return name
end

function ENT:GetShipment()
	local shipment = self:getNetVar("shipment", {})

	return shipment
end

function ENT:GetRandom()
	local random = self:getNetVar("random", false)

	return random
end

function ENT:GetRandomAmt()
	local randomAmt = self:getNetVar("randomAmt", 1)

	return randomAmt
end

function ENT:GetCost()
	local cost = tonumber(self:getNetVar("cost", self.cost))
	
	return cost
end

function ENT:GetCD()
	local cd = tonumber(self:getNetVar("cd", self.cd))
	
	return cd
end

function ENT:GetCDTbl()
	local cdTbl = self:getNetVar("players", {})
	
	return cdTbl
end

function ENT:GetTrait()
	local trait = self:getNetVar("trait", self.trait)
	
	return trait
end