local PLUGIN = PLUGIN

AddCSLuaFile()

SWEP.PrintName = "Combat"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
--SWEP.Author = "Chancer"
SWEP.Instructions = "Prinary Fire: Select/Deselect targeted entity.\nSecondary Fire: Use selected command. (Default: Attack)\nReload: Action Menu."
SWEP.Purpose = "Managing the attacks and actions of yourself or a Combat Entity."
SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.ViewTranslation = 4
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Delay = 0.1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.UseHands = false
SWEP.LowerAngles = Angle(15, -10, -20)
SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true
SWEP.HoldType = "normal"
ALWAYS_RAISED["nut_cswep"] = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Nutscript - Combat"
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetActions(self.Owner)
	self.actNum = 1
end

function SWEP:Deploy()
	self:SetActions(self.Owner)
	self.actNum = 1
end

function SWEP:Reload()
	if not self.actions then self:SetActions(self.Owner) end
	if (self.nextReload or 0) < CurTime() then
		self.nextReload = CurTime() + 0.5
		self:OpenActionList()
	end
end

function SWEP:OpenActionList()
	local actions = self:SetActions(self:getNetVar("selected", self.Owner))
	if SERVER then netstream.Start(self.Owner, "CSWep_openActionMenu", self) end
end

function SWEP:GetActions()
	if not self.actions then self:SetActions() end
	local actions = self:getNetVar("actions", self.actions)
	return actions
end

function SWEP:SetActions(target)
	if not IsValid(target) then return end
	local actions = target:getActions()
	if SERVER then self:setNetVar("actions", actions) end
	self.actions = actions
	return self.actions
end

function SWEP:resetAction()
	self.actNum = 1
	if SERVER then netstream.Start(self.Owner, "CSWep_actionReset", self) end
end

--this is clientside
function SWEP:selectAction(actNum)
	self.actNum = actNum
	netstream.Start("CSWep_action", actNum, self)
end

--this is clientside
function SWEP:selectPart(partString)
	self.partString = partString
	netstream.Start("CSWep_part", partString, self)
end

--this is clientside
--[[
function SWEP:selectWeapon(item)
	self.selectedWeapon = item
	netstream.Start("CSWep_weapon", item.id, self)
end
--]]
if SERVER then
	netstream.Hook("CSWep_action", function(client, actNum, swep)
		if IsValid(swep) and swep.GetActions then
			local actions = swep:GetActions()
			swep.actNum = actNum
			client:notify("Selected " .. (actions[actNum] and actions[actNum].name or ""))
		end
	end)

	netstream.Hook("CSWep_part", function(client, partString, swep)
		if IsValid(swep) then
			swep.partString = partString
			client:notify("Targeting " .. partString)
		end
	end)

	netstream.Hook("CSWep_weapon", function(client, itemID, swep)
		if IsValid(swep) then
			local itemTbl = nut.item.instances[itemID]
			if itemTbl then
				swep.selectedWeapon = itemTbl
				client:notify("Selected " .. itemTbl:getName())
			end
		end
	end)
else
	netstream.Hook("CSWep_actionReset", function(swep, client) swep:resetAction() end)
end

function SWEP:selectTarget(entity)
	if CLIENT then return end
	self:setNetVar("actions", nil)
	if IsValid(entity) and entity.combat then
		self:setNetVar("selected", entity)
		self:setNetVar("selectedName", entity:Name())
		self.Owner:notify("Selected " .. entity:Name() .. ".")
		self.actNum = 1
		self:SetActions(entity) --sets potential actions to the selected units'
	else
		if self:getNetVar("selected") then
			self:setNetVar("selected", nil)
			self.Owner:notify("Deselected.")
			self.actNum = 1
			self:SetActions(self.Owner) --sets potential actions to the wielder of the weapon
		end
	end
end

--more will be added to this later
function SWEP:canAttackPlayer()
	return true
	--[[
	if(IsValid(self:getNetVar("selected")) or self.Owner:IsAdmin()) then
		return true
	else
		return false
	end
	--]]
end

function SWEP:PrimaryAttack()
	local data = {}
	data.start = self.Owner:GetShootPos()
	data.endpos = data.start + self.Owner:GetAimVector() * 4096
	data.filter = {self.Owner, self}
	local trace = util.TraceLine(data)
	local actions = self:GetActions()
	local action = actions[self.actNum]
	local partString = self.partString or "Body"
	if not action then return end
	local weapon = action.weapon --self.selectedWeapon
	if SERVER and trace.Hit then
		local client = self.Owner
		local attacker = self:getNetVar("selected", client)
		if not IsValid(attacker) then
			self:selectTarget()
			attacker = client
		end

		local actionTbl = {}
		if action.uid then actionTbl = table.Copy(ACTS.actions[action.uid]) end
		local actionInterrupt = hook.Run("nut_ActionInterrupt", action, attacker)
		if actionInterrupt then
			client:notify(actionInterrupt)
			return
		end

		if not action.attackOverwrite and not actionTbl.attackOverwrite then --this lets you make actions that just print stuff or run functions
			local data = {
				attacker = attacker,
				trace = trace,
				partString = partString,
				weapon = weapon,
				action = action,
				actionTbl = actionTbl,
			}

			PLUGIN:attackStart(client, data)
		else
			actionTbl:attackOverwrite(attacker, trace, partString, weapon)
		end

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local data = {}
		data.start = self.Owner:GetShootPos()
		data.endpos = data.start + self.Owner:GetAimVector() * 4096
		data.filter = {self.Owner, self}
		local trace = util.TraceLine(data)
		if trace.Hit then
			local entity = trace.Entity
			if IsValid(entity) and (self.Owner:IsAdmin() or (entity.combat and entity:GetCreator() == self.Owner)) then
				self:selectTarget(entity)
			else
				self:selectTarget() --reset target
			end
		end
	end
end

local schemaUI = nut.config.get("schemaUI", "fonvui")
--local barLeft = Material("materials/fonvui/hud/hud_left_main.png")
--local barRight = Material("materials/fonvui/hud/hud_right_main.png")
local barLeft = Material("materials/" .. schemaUI .. "/hud/hud_left_main.png")
local barRight = Material("materials/" .. schemaUI .. "/hud/hud_right_main.png")
function SWEP:DrawHUD()
	if CLIENT then
		local client = LocalPlayer()
		local alpha = 255
		local scrModX = ScrW() / 1920
		local scrModY = ScrH() / 1080
		local actions = self:GetActions()
		local action = actions[self.actNum] or {}
		local user = self:getNetVar("selected", client)
		if not IsValid(user) then
			user = client
		elseif user ~= client then
			local name = self:getNetVar("selectedName", "Unnamed")
			nut.util.drawText(name .. " Selected", ScrW() * 0.5, ScrH() * 0.3, ColorAlpha(Color(50, 50, 255), alpha), 1, 1, "nutCombatTarget", alpha * 1)
		end

		local altPressed
		if client:KeyDown(IN_WALK) then --self targetting
			altPressed = true
		end

		if (self.nextCEntTrace or 0) < CurTime() then --whatever is in front of you
			local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector() * 4096
			data.filter = {self.Owner, self}
			local trace = util.TraceLine(data)
			if trace.Hit then
				local entity = trace.Entity
				if (action and action.selfOnly) or altPressed then --self target
					self.viewed = user
				elseif entity.combat or entity:IsPlayer() then
					self.viewed = entity
					self.nextCEntTrace = CurTime() + 1
				else
					self.viewed = nil
				end

				if action then
					if action and action.radius then
						local targetPos
						if self.viewed then
							targetPos = self.viewed:GetPos()
						else
							targetPos = trace.HitPos
						end

						client.ccAreaShow = {targetPos, action.radius}
					else
						client.ccAreaShow = nil
					end
				else
					client.ccAreaShow = nil
				end
			end
		end

		local posX
		local posY
		local textX
		--turn status
		local APCircle = client:getNetVar("showAPCircle")
		local turnOver = client:getNetVar("turnOverIcon")
		if APCircle or turnOver then
			--they have set their turn to over.
			posX = ScrW() * 0.5 - 100 * scrModX
			posY = 70 * scrModY
			local boxX = 200 * scrModX
			textX = posX + boxX * 0.5
			local turnState
			if turnOver then
				turnState = "Turn Over"
			elseif APCircle then
				turnState = "Your Turn"
			end

			surface.SetFont("nutCombatHUD")
			local textSizeX, textSizeY = surface.GetTextSize(turnState)
			surface.SetDrawColor(0,47,0,150)
			surface.DrawRect(posX, posY, boxX, textSizeY * 1.5)
			surface.SetDrawColor(0,238,0,150)
			surface.DrawOutlinedRect(posX, posY, boxX, textSizeY * 1.5, 1)
			posY = posY + textSizeY * 0.75
			nut.util.drawText(turnState, textX, posY, Color(0,238,0,150), 1, 1, "nutCombatHUD")
		end

		--ap display
		local AP = (user.getAP and user:getAP()) or 0
		local APMax = (user.getAPMax and user:getAPMax()) or 0
		if AP and APMax then
			posX = ScrW() - 230 * scrModX
			posY = 50 * scrModY
			local boxX = 200 * scrModX
			textX = posX + boxX * 0.5
			local apString = "AP: (" .. AP .. "/" .. APMax .. ")"
			surface.SetFont("nutCombatHUD")
			local textSizeX, textSizeY = surface.GetTextSize(apString)
			surface.SetDrawColor(0,47,0,150)
			surface.DrawRect(posX, posY, boxX, textSizeY * 1.5)
			surface.SetDrawColor(0,238,0,150)
			surface.DrawOutlinedRect(posX, posY, boxX, textSizeY * 1.5, 1)
			posY = posY + textSizeY * 0.75
			nut.util.drawText(apString, textX, posY, surface.SetDrawColor(0,238,0,150), 1, 1, "nutCombatHUD")
		end

		--buff display
		local buffs = user.getBuffs and user:getBuffs()
		if buffs then
			posX = ScrW() - 230 * scrModX
			posY = posY + 50 * scrModY
			local heightBuff = (40 + 35 * table.Count(buffs)) * scrModY
			local boxX = 200 * scrModX
			textX = posX + boxX * 0.5
			surface.SetDrawColor(0,47,0,150)
			surface.DrawRect(posX, posY, boxX, heightBuff)
			surface.SetDrawColor(0,238,0,150)
			surface.DrawOutlinedRect(posX, posY, boxX, heightBuff, 1)
			posY = posY + 20
			nut.util.drawText("[BUFFS]", textX, posY, Color(0,238,0,150), 1, 1, "nutCombatHUD")
			for k, v in pairs(buffs) do
				if v.name then
					posY = posY + 35 * scrModY
					local nameDur = v.name .. ((v.duration and (" " .. v.duration .. "T")) or "")
					nut.util.drawText(nameDur, textX, posY, Color(0,238,0,150), 1, 1, "nutCombatHUD", alpha * 1)
				end
			end
		end

		--cooldown display
		local cooldowns = user.getCooldowns and user:getCooldowns()
		if cooldowns then
			posX = ScrW() - 230 * scrModX
			posY = posY + 50 * scrModY
			local heightCD = (40 + 35 * table.Count(cooldowns)) * scrModY
			local boxX = 200 * scrModX
			textX = posX + boxX * 0.5
			surface.SetDrawColor(0,47,0,150)
			surface.DrawRect(posX, posY, boxX, heightCD)
			surface.SetDrawColor(0,238,0,150)
			surface.DrawOutlinedRect(posX, posY, boxX, heightCD, 1)
			posY = posY + 20
			nut.util.drawText("[COOLDOWNS]", textX, posY, Color(0,238,0,150), 1, 1, "nutCombatHUD")
			for k, v in pairs(cooldowns) do
				local actionTbl = ACTS.actions[k]
				if not actionTbl then
					local weaponID = v.weapon
					if weaponID then
						local realID = string.Left(k, #k - #tostring(weaponID))
						actionTbl = ACTS.actions[realID]
					end
				end

				if actionTbl then
					posY = posY + 35 * scrModY
					local nameDur = (actionTbl.name or "Unknown") .. " " .. (v.duration or 0) .. "T"
					nut.util.drawText(nameDur, textX, posY, Color(0,238,0,150), 1, 1, "nutCombatHUD", alpha * 1)
				end
			end
		end

		--HP display
		local hp = user.getHP and user:getHP()
		if hp then
			posX = ScrW() - 381 * scrModX
			posY = ScrH() - 128 * scrModY
			local hpMax = user:getMaxHP()
			surface.SetDrawColor(0,238,0,150)
			surface.SetMaterial(barRight)
			surface.DrawTexturedRect(posX, posY, 381 * scrModX, 256 * scrModY)
			local ratio = hp / hpMax
			local tickX = ScrW() - 19 * scrModX
			local tickY = posY + 45 * scrModY
			local ticks = math.Round(60 * ratio)
			local tickW = 4 * scrModX
			local tickH = 18 * scrModY
			for i = 1, ticks do
				surface.SetDrawColor(0,238,0,150)
				surface.DrawRect(tickX, tickY, tickW, tickH)
				tickX = tickX - (tickW + 1)
			end

			posX = posX + 110 * scrModX
			posY = posY + 95 * scrModY
			hp = math.Round(hp)
			hpMax = math.Round(hpMax)
			local hpString = "HP:(" .. math.max(hp, 0) .. "/" .. hpMax .. ")"
			nut.util.drawText(hpString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
		end

		local weapon = action.weapon
		local weaponItem = weapon and nut.item.instances[weapon]
		if weaponItem and weaponItem.magSize then
			posX = ScrW() - 92 * scrModX
			posY = ScrH() - 33 * scrModY
			local magSize = weaponItem:getData("magSize", weaponItem.magSize)
			local ammo = weaponItem:getData("currentMag", {})
			local ammoID, ammoAmt = ammo[1], ammo[2]
			if not ammoAmt then ammoAmt = 0 end
			if ammoAmt then
				local ammoString = "A:(" .. ammoAmt .. "/" .. magSize .. ") "
				nut.util.drawText(ammoString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
			end
		end

		if IsValid(self.viewed) then
			local textSizeX, textSizeY
			local name = self.viewed:Name()
			if action then
				local actionTbl = ACTS.actions[action.uid] or {}
				local accuracy = 0
				local rangeText
				local weapon = action.weapon
				if weapon then
					local weaponItem = nut.item.instances[weapon]
					accuracy = user:getAccuracy(weaponItem)
					--adjusts accuracy before we calculate hit chance
					accuracy = accuracy + (actionTbl.accuracy or 0)
					accuracy = accuracy * (actionTbl.accuracyMult or 1)
					--accuracy altered by range
					if weaponItem and weaponItem.range then
						local dist = self.viewed:GetPos():Distance(client:GetPos())
						accuracy, rangeText = PLUGIN:RangeAccuracyModify(accuracy, weaponItem, dist)
					end
				else
					accuracy = user:getAccuracy()
					--adjusts accuracy before we calculate hit chance
					accuracy = accuracy + (actionTbl.accuracy or 0)
					accuracy = accuracy * (actionTbl.accuracyMult or 1)
				end

				--parts
				local part = self.partString or "Body"
				local partMod = PLUGIN:getPartsModifiers(part, weaponItem)
				accuracy = PLUGIN:PartAttackModifyAccuracy(accuracy, partMod)
				local hitChance = PLUGIN:calcHitChance(accuracy, self.viewed)
				hitChance = math.Round(hitChance)
				posX = ScrW() * 0.5
				posY = ScrH() * 0.7
				surface.SetFont("nutCombatTarget")
				--string that tells you what you're about to do (action)
				part = "[" .. part .. "]"
				local actionName = action.name or "Unknown Action"
				local actionString = "Secondary Fire to " .. actionName .. part .. "."
				nut.util.drawText(actionString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
				--offset the text
				textSizeX, textSizeY = surface.GetTextSize(actionString)
				posY = posY + textSizeY
				--target string
				if not action.selfOnly then
					local targetString = "Target: " .. name
					nut.util.drawText(targetString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
					--offset the text
					textSizeX, textSizeY = surface.GetTextSize(targetString)
					posY = posY + textSizeY
					if rangeText then
						--string that tells you your chance to hit your target
						local rangeString = "Range: " .. rangeText
						nut.util.drawText(rangeString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
						--offset the text
						textSizeX, textSizeY = surface.GetTextSize(rangeString)
						posY = posY + textSizeY
					end

					--string that tells you your chance to hit your target
					local chanceString = "Chance: " .. hitChance .. " %"
					nut.util.drawText(chanceString, posX, posY, Color(0,238,0,150), 1, 1, "nutCombatTarget")
				end
			end
		end
	end
end

function SWEP:Holster(weapon)
	local client = self.Owner
	client.ccAreaShow = nil
	return true
end

--sends CEnt action lists to client
if CLIENT then
	netstream.Hook("CSWep_openActionMenu", function(swep)
		local actionList = vgui.Create("nutActionList")
		actionList.swep = swep
		actionList.actions = swep:GetActions()
	end)

	netstream.Hook("CSWep_loadActions", function(swep, actions) swep.actions = util.JSONToTable(actions) end)
end