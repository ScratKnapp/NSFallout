local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
	local client = LocalPlayer()
	local char = client:getChar()

	nut.gui.status = self

	self:SetSize(self:GetParent():GetSize())

	self.name = self:Add("DLabel")
	self.name:Dock(TOP)
	self.name:SetTall(25)
	self.name:SetFont("nutMediumFont")
	self.name:SetTextColor(color_white)
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.name:DockMargin(0, 10, 0, 0)
	self.name:SetText(client:Name())

	--level
	self.level = self:Add("DLabel")
	self.level:Dock(TOP)
	self.level:SetTall(25)
	self.level:SetFont("nutMediumFont")
	self.level:SetTextColor(color_white)
	self.level:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.level:DockMargin(0, 10, 0, 0)

	local level = LocalPlayer():getLevel()
	local extra = char:getData("points")
	self.level:SetText("Level: " ..level - (extra or 0).. ((extra and " (+" ..extra.. ")") or ""))

	--health
	self.hp = self:Add("DLabel")
	self.hp:Dock(TOP)
	self.hp:SetTall(25)
	self.hp:SetFont("nutMediumFont")
	self.hp:SetTextColor(color_white)
	self.hp:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.hp:DockMargin(0, 10, 0, 0)

	local hp = client:getHP()
	local hpMax = client:getMaxHP()
	if (hp and hpMax) then
		self.hp:SetText("Health: " ..hp.. "/" ..hpMax)
	end		
	
	--mana
	--[[
	self.mana = self:Add("DLabel")
	self.mana:Dock(TOP)
	self.mana:SetTall(25)
	self.mana:SetFont("nutMediumFont")
	self.mana:SetTextColor(color_white)
	self.mana:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.mana:DockMargin(0, 10, 0, 0)	
	
	local mana = client:getMP()
	local manaMax = client:getMaxMP()
	if (mana and manaMax) then
		self.mana:SetText("Current Mana: " ..mana.. "/" ..manaMax)
	end
	--]]
	
	--weight
	local weight = client:getWeight()
	local weightMax = client:getMaxWeight()
	if (weight and weightMax) then
		self.weight = self:Add("DLabel")
		self.weight:Dock(TOP)
		self.weight:SetTall(25)
		self.weight:SetFont("nutMediumFont")
		self.weight:SetTextColor(color_white)
		self.weight:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.weight:DockMargin(0, 10, 0, 0)
		self.weight:SetText("Weight: " ..weight.. "/" ..weightMax.. " kg")
	end
	
	--damage
	local damage = client:getDamage()
	if(damage) then
		self.damage = self:Add("DLabel")
		self.damage:Dock(TOP)
		self.damage:SetTall(25)
		self.damage:SetFont("nutMediumFont")
		self.damage:SetTextColor(color_white)
		self.damage:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.damage:DockMargin(0, 10, 0, 0)
		
		local dmgString = ""
		local totalDam = 0
		for k, v in pairs(damage) do
			--dmgString = dmgString..(v.dmg or 0)..(v.weap and " {" ..v.weap.. ": " or "{")..(v.dmgT or "Crush").. "}"
			totalDam = totalDam + (v.dmg or 0)
			
			if(k == #damage and k > 1) then
				--dmgString = dmgString.. " [" ..totalDam.. "]"
			end
		end
		
		self.damage:SetText("Average Damage: " ..totalDam.. " damage.")
	end	
	
	--accuracy (small)
	local accuracy = client:getAccuracy()
	if(accuracy) then
		self.accuracy = self:Add("DLabel")
		self.accuracy:Dock(TOP)
		--self.accuracy:SetTall(25)
		self.accuracy:SetFont("nutSmallFont")
		--self.accuracy:SetTextColor(color_white)
		self.accuracy:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.accuracy:DockMargin(2,2,2,2)
		self.accuracy:SetText("   Accuracy: " ..accuracy)
	end	
	
	--magic
	--[[
	local magic = client:getMagic()
	if(magic) then
		self.magic = self:Add("DLabel")
		self.magic:Dock(TOP)
		self.magic:SetTall(25)
		self.magic:SetFont("nutMediumFont")
		self.magic:SetTextColor(color_white)
		self.magic:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.magic:DockMargin(0, 10, 0, 0)
		
		self.magic:SetText("Magic Bonus: " ..magic.. ".")
	end	
	--]]
	
	--armor
	local armor = client:getArmor()
	if(armor) then
		self.armor = self:Add("DLabel")
		self.armor:Dock(TOP)
		self.armor:SetTall(25)
		self.armor:SetFont("nutMediumFont")
		self.armor:SetTextColor(color_white)
		self.armor:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.armor:DockMargin(0, 10, 0, 0)
		self.armor:SetText("Total Armor: " ..armor)
	end
	
	--evasion (small)
	local evasion = client:getEvasion()
	if(evasion) then
		self.evasion = self:Add("DLabel")
		self.evasion:Dock(TOP)
		--self.evasion:SetTall(25)
		self.evasion:SetFont("nutSmallFont")
		--self.evasion:SetTextColor(color_white)
		self.evasion:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.evasion:DockMargin(2,2,2,2)
		self.evasion:SetText("   Evasion: " ..evasion)
	end	
	
	for k, v in pairs(PLUGIN:getPartsModifiers()) do
		local subArmor = self:Add("DLabel")
		subArmor:Dock(TOP)
		subArmor:SetTall(25)
		subArmor:SetFont("nutSmallFont")
		--subArmor:SetTextColor(color_white)
		subArmor:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		subArmor:DockMargin(0, 6, 0, 0)
		subArmor:SetText(" " ..k.. " Armor: " ..(client:getArmor(k) or 0))
	end
	
	--resistances
	self.resL = self:Add("DLabel")
	self.resL:Dock(TOP)
	self.resL:SetTall(25)
	self.resL:SetFont("nutMediumFont")
	self.resL:SetTextColor(color_white)
	self.resL:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.resL:DockMargin(0, 10, 0, 0)
	self.resL:SetText("Resistances")
	
	local res = client:getRes()
	for k, v in pairs(res) do
		local resist = self:Add("DLabel")
		resist:Dock(TOP)

		resist:SetWrap(true)
		resist:SetAutoStretchVertical(true)
		resist:DockMargin(2,2,2,2)
		resist:SetFont("nutSmallFont")
		
		local name = (nut.plugin.list["spells"].dmgTypes[k] and nut.plugin.list["spells"].dmgTypes[k].name) or (EFFS.effects[k] and EFFS.effects[k].name)
		if(name) then
			resist:SetText("   " ..name.. " Resistance: " ..(v * 100).. "%.")
		elseif(k == "res") then
			resist:SetText("   General Resistance: " ..(v * 100).. "%.")
		else
			resist:SetText("   Unknown Resistance")
		end
	end	
	
	--resistances
	self.ampL = self:Add("DLabel")
	self.ampL:Dock(TOP)
	self.ampL:SetTall(25)
	self.ampL:SetFont("nutMediumFont")
	self.ampL:SetTextColor(color_white)
	self.ampL:SetExpensiveShadow(1, Color(0, 0, 0, 150))
	self.ampL:DockMargin(0, 10, 0, 0)
	self.ampL:SetText("Amplifications")
	
	local amp = client:getAmp()
	for k, v in pairs(amp) do
		local amp = self:Add("DLabel")
		amp:Dock(TOP)

		amp:SetWrap(true)
		amp:SetAutoStretchVertical(true)
		amp:DockMargin(2,2,2,2)
		amp:SetFont("nutSmallFont")
		
		local name = (nut.plugin.list["spells"].dmgTypes[k] and nut.plugin.list["spells"].dmgTypes[k].name) or (EFFS.effects[k] and EFFS.effects[k].name)
		if(name) then
			amp:SetText("   " ..name.. " Amplification: " ..(v * 100).. "%.")
		elseif(k == "end") then
			amp:SetText("   General Amplification: " ..(v * 100).. "%.")
		else
			amp:SetText("   Unknown Amplification")
		end
	end
		
	--equipment
	local inventory = char:getInv()
	
	self.equip = {}
	
	local x, y = 500, 0
	
	for k, v in pairs(inventory:getItems()) do
		if(v:getData("equip")) then
			local equip = self:Add("DLabel")
			equip:SetPos(x, y)
			--equip:Dock(RIGHT)
			equip:SetTall(25)
			equip:SetWide(300)
			equip:SetFont("nutMediumFont")
			equip:SetTextColor(color_white)
			equip:SetExpensiveShadow(1, Color(0, 0, 0, 150))
			--equip:DockMargin(0, 10, 0, 0)
			equip:SetText(v:getName())
			
			--self.equip[k] = equip
			
			local dmg = v:getData("dmg", v.dmg)
			local dmgT = v:getData("dmgT", v.dmgT) or "Crush"
			if(dmg) then
				y = y + 25
			
				local dmgL = self:Add("DLabel")

				dmgL:SetFont("nutSmallFont")
				dmgL:SetPos(x, y)
				dmgL:SetWide(300)
				dmgL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				dmgL:SetText("   Base Damage: " ..dmg.. " {" ..dmgT.. "}")
			end	
			
			local armor = v:getData("armor", v.armor)
			if(armor) then
				y = y + 25
			
				local armorL = self:Add("DLabel")

				armorL:SetFont("nutSmallFont")
				armorL:SetPos(x, y)
				armorL:SetWide(300)
				armorL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				armorL:SetText("   Physical Armor: " ..armor)
			end		
			
			local weight = v:getData("weight", v.weight)
			if(weight) then
				y = y + 25
			
				local weightL = self:Add("DLabel")

				weightL:SetFont("nutSmallFont")
				weightL:SetPos(x, y)
				weightL:SetWide(300)
				weightL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				weightL:SetText("   Weight: " ..weight)
			end
			
			y = y + 25
		end
	end	
	
	
	--buffs here
	x, y = 900, 0
	
	for k, v in pairs(client:getBuffs()) do
		
		--[[
		if(v:getData("equip")) then
			local equip = self:Add("DLabel")
			equip:SetPos(x, y)
			--equip:Dock(RIGHT)
			equip:SetTall(25)
			equip:SetWide(300)
			equip:SetFont("nutMediumFont")
			equip:SetTextColor(color_white)
			equip:SetExpensiveShadow(1, Color(0, 0, 0, 150))
			--equip:DockMargin(0, 10, 0, 0)
			equip:SetText(v:getName())
			
			--self.equip[k] = equip
			
			local dmg = v:getData("dmg", v.dmg)
			local dmgT = v:getData("dmgT", v.dmgT) or "Crush"
			if(dmg) then
				y = y + 25
			
				local dmgL = self:Add("DLabel")

				dmgL:SetFont("nutSmallFont")
				dmgL:SetPos(x, y)
				dmgL:SetWide(300)
				dmgL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				dmgL:SetText("   Base Damage: " ..dmg.. " {" ..v.dmgT.. "}")
			end	
			
			local armor = v:getData("armor", v.armor)
			if(armor) then
				y = y + 25
			
				local armorL = self:Add("DLabel")

				armorL:SetFont("nutSmallFont")
				armorL:SetPos(x, y)
				armorL:SetWide(300)
				armorL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				armorL:SetText("   Physical Armor: " ..armor)
			end		
			
			local weight = v:getData("weight", v.weight)
			if(weight) then
				y = y + 25
			
				local weightL = self:Add("DLabel")

				weightL:SetFont("nutSmallFont")
				weightL:SetPos(x, y)
				weightL:SetWide(300)
				weightL:SetExpensiveShadow(1, Color(0, 0, 0, 150))

				weightL:SetText("   Weight: " ..weight)
			end
			
			y = y + 25
		end
		--]]
	end	
end

function PANEL:OnRemove()
	--[[
	if(self.equip) then
		for k, v in pairs(self.equip) do
			if(IsValid(v)) then
				v:Remove()
			end
		end
	end
	--]]
end


vgui.Register("nutStatus", PANEL, "EditablePanel")

--[[
hook.Add("CreateMenuButtons", "nutStatus", function(tabs)
	tabs["Status"] = function(panel)
		panel:Add("nutStatus")
	end
end)
--]]