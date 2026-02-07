ENT.Type = "anim"
ENT.PrintName = "Factory"
ENT.Author = ""
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "Nutscript - Factories"
ENT.AutomaticFrameAdvance = true

ENT.model = "models/props_junk/wood_crate002a.mdl"

--[[
ENT.process = {
	[1] = {
		name = "Sheet Metal",
		required = {
			["mat_metal_raw"] = 1,
		},
		results = {
			["mat_metal"] = 1,
		},
		time = 60,
	},
}
--]]

function ENT:Initialize()
	if(SERVER) then
		local model
		if(self.models) then
			model = self.models[math.random(#self.models)]
		else
			model = self.model
		end

		self:SetModel(model)
		
		if(self.material) then
			self:SetMaterial(self.material)
		end
		
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:EnableGravity(true)
			--physObj:Sleep()
			physObj:EnableCollisions(true)
		end
	end
end

if (SERVER) then
	function ENT:Think()
		--[[
		if(!self:IsPlayerHolding()) then
			local physObj = self:GetPhysicsObject()
			
			if(IsValid(physObj) and !physObj:IsAsleep()) then
				physObj:Sleep()
			end
		end
		--]]
	end	
	
	function ENT:Use(client)
		local process = self:getNetVar("process")
		if(process) then
			local processTime = self:getNetVar("processTime", nil)
			if(processTime < CurTime()) then
				self:FinishProcess(client)
			else
				client:notify("Factory is processing.")
			end
		else
			netstream.Start(client, "nut_factoryMenu", self)
		end
	end
	
	function ENT:getSaveData()
		local saveData = {}
	
		return saveData
	end
	
	netstream.Hook("nut_factoryStart", function(client, entity, option)
		if(IsValid(entity)) then
			entity:StartProcess(option, client)
		end
	end)
	
	netstream.Hook("nut_factoryFinish", function(client, entity, option)
		if(IsValid(entity)) then
			entity:FinishProcess(client)
		end
	end)
	
	function ENT:StartProcess(option, client)
		local processTbl = table.Copy(self.process[option])
		if(processTbl) then
			local char = client:getChar()
			if(char) then
				local inventory = char:getInv()
				local items = inventory:getItems()
				
				local removeItems = {}
				
				if(processTbl.required) then
					local required = table.Copy(processTbl.required)
				
					for itemID, item in pairs(items) do
						--if we have an item we're looking for
						if(required[item.uniqueID]) then
							local amount = item:getData("Amount", 1)
							
							--the remaining amount of items we need
							local remainder = required[item.uniqueID] - amount
							
							--if we have remainder, this item was used up
							if(remainder > 0) then 
								removeItems[item] = 0
							else --if no remainder, then this item has some left
								removeItems[item] = amount - required[item.uniqueID]
							end
							
							--updates the table so we know we need more
							required[item.uniqueID] = remainder
						end
					end

					--if we dont have everything we need we stop here
					for k, v in pairs(required) do
						if(v > 0) then
							client:notify("Insufficient resources.")
							return false
						end
					end
				
					--removes the detected required items
					for item, newAmount in pairs(removeItems) do
						if(item) then
							if(newAmount > 0) then --sets items to new amounts
								item:setData("Amount", newAmount)
							else --if theres nsothing left remove the item
								item:remove()
							end
						end
					end
				end
				
				self:setNetVar("process", option)
				self:setNetVar("processTime", CurTime() + processTbl.time or 0)
				
				self:EmitSound("ambient/machines/combine_terminal_idle3.wav", 75, 120)
			end
		end
	end
	
	function ENT:FinishProcess(client)
		local option = self:getNetVar("process")
		if(!option) then return false end
	
		local processTbl = self.process[option]
		if(processTbl) then
			local char = client:getChar()
			if(char) then
				local inventory = char:getInv()
			
				if(processTbl.results) then
					local position = client:getItemDropPos()
				
					for uniqueID, amount in pairs(processTbl.results) do
						inventory:addSmart(uniqueID, amount, position)
					end
				end
				
				self:setNetVar("process", nil)
				self:setNetVar("processTime", nil)
				
				self:EmitSound("ambient/machines/keyboard6_clicks.wav", 75, 50)
			end
		end
	end
else
	--open gui menu
	netstream.Hook("nut_factoryMenu", function(entity)
		local frame = vgui.Create("DFrame")
		frame:SetSize(450, 600)
		frame:Center()
		frame:SetTitle(entity.displayName or "Factory")
		frame:MakePopup()
		frame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", frame)
		scroll:Dock(FILL)
		
		local options = entity.process
		
		for k, v in pairs(entity.process) do
			local finishB = vgui.Create("DButton", scroll)
			finishB:SetSize(60,30)
			
			local toolTip = ""
			
			if(v.required) then
				toolTip = toolTip.. "Required: \n"
				
				for item, amount in pairs(v.required) do
					local itemTbl = nut.item.list[item]
					local name = (itemTbl and itemTbl.name) or item
				
					toolTip = toolTip.. " " ..name.. ": " ..amount.. "\n"
				end
			end
			
			if(v.results) then
				toolTip = toolTip.. "Results: \n"
				
				for item, amount in pairs(v.results) do
					local itemTbl = nut.item.list[item]
					local name = (itemTbl and itemTbl.name) or item
				
					toolTip = toolTip.. " " ..name.. ": " ..amount.. "\n"
				end
			end
			
			finishB:SetText("")
			finishB:SetTooltip(toolTip)
			finishB:Dock(TOP)
			finishB.DoClick = function()
				netstream.Start("nut_factoryStart", entity, k)
				
				frame:Remove()
			end
			finishB.Paint = function(panel, w, h)
				surface.SetDrawColor(0, 0, 0, 150)
				surface.DrawOutlinedRect(0, 0, w, h, 2)
				
				surface.SetFont("nutSmallFont")
				local textX, textY = surface.GetTextSize(v.name)
				surface.SetTextColor(255,255,255)
				surface.SetTextPos(w*0.5-textX*0.5, h*0.5-textY*0.5)
				
				surface.DrawText(v.name)
			end
		end
		
		local cancelB = vgui.Create("DButton", scroll)
		cancelB:SetSize(60,30)
		cancelB:SetText("")
		cancelB:Dock(TOP)
		cancelB.DoClick = function()
			frame:Remove()
		end		
		cancelB.Paint = function(panel, w, h)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
			
			local textX, textY = surface.GetTextSize("Close")

			surface.SetFont("nutSmallFont")
			surface.SetTextColor(255,255,255)
			surface.SetTextPos(w*0.5-textX*0.5, h*0.5-textY*0.5)
			
			surface.DrawText("Close")
		end
	end)

	ENT.DrawEntityInfo = true
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get
	local ScrW = ScrW()
	
	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y
	
		local process = self:getNetVar("process", -1)
		local processTbl = self.process[process]
		if(processTbl) then
			local finishTime = self:getNetVar("processTime", 1)
		
			local requiredTime = processTbl.time or 1
		
			local progress = ((CurTime() - finishTime)/requiredTime)+1
			progress = math.min(progress, 1)

			local emptyBarW = ScrW*0.1

			local message = "Producing..."
			if(progress == 1) then
				message = "[ Complete ]"
			end
		
			local tx, ty = drawText(message, x, y-12, Color(255,255,255), 1, 1, nil, alpha * 2)

			nut.bar.draw(x - emptyBarW*0.5, y, emptyBarW, 14, 50, Color(0,0,0))
			nut.bar.draw(x - emptyBarW*0.5, y, emptyBarW, 14, progress, Color(50,225,225))
		end
		
		local tx, ty = drawText(self.displayName or "Factory", x, y-28, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 2)
	end
end