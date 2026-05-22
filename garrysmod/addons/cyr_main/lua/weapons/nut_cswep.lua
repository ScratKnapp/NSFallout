-- Combat SWEP. Lives in cyr_main so iterating on it doesn't require rebuilding
-- the fallout gamemode. GMod auto-loads SWEPs from lua/weapons/<class>.lua and
-- calls AddCSLuaFile() automatically. PLUGIN references resolve at runtime via
-- nut.plugin.list.combat (the plugin is loaded by the time any SWEP method
-- actually runs).

ALWAYS_RAISED = ALWAYS_RAISED or {}

SWEP.PrintName = "Combat"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Instructions = "Primary Fire: Select/Deselect targeted entity.\nSecondary Fire: Use selected command. (Default: Attack)\nReload: Action Menu."
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

local function combatPlugin()
	return nut.plugin and nut.plugin.list and nut.plugin.list.combat
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetActions(self:GetOwner())
	self.actNum = 1
end

function SWEP:Deploy()
	self:SetActions(self:GetOwner())
	self.actNum = 1
end

function SWEP:Reload()
	if not self.actions then self:SetActions(self:GetOwner()) end
	if (self.nextReload or 0) < CurTime() then
		self.nextReload = CurTime() + 0.5
		self:OpenActionList()
	end
end

function SWEP:OpenActionList()
	self:SetActions(self:getNetVar("selected", self:GetOwner()))
	if SERVER then netstream.Start(self:GetOwner(), "CSWep_openActionMenu", self) end
end

function SWEP:GetActions()
	if not self.actions then self:SetActions() end
	return self:getNetVar("actions", self.actions)
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
	if SERVER then netstream.Start(self:GetOwner(), "CSWep_actionReset", self) end
end

function SWEP:selectAction(actNum)
	self.actNum = actNum
	netstream.Start("CSWep_action", actNum, self)
end

function SWEP:selectPart(partString)
	self.partString = partString
	netstream.Start("CSWep_part", partString, self)
end

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

	-- V.A.T.S. commit: client picked a target + part + action; run the same
	-- attack pipeline PrimaryAttack uses, but with the chosen target instead
	-- of trace.Entity.
	netstream.Hook("CSWep_vatsAttack", function(client, target, partString, actNum, swep)
		if not IsValid(swep) or swep ~= client:GetActiveWeapon() then return end
		if swep.VATSExecuteAttack then
			swep:VATSExecuteAttack(target, partString, actNum)
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
		self:GetOwner():notify("Selected " .. entity:Name() .. ".")
		self.actNum = 1
		self:SetActions(entity)
	else
		if self:getNetVar("selected") then
			self:setNetVar("selected", nil)
			self:GetOwner():notify("Deselected.")
			self.actNum = 1
			self:SetActions(self:GetOwner())
		end
	end
end

function SWEP:canAttackPlayer()
	return true
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	local data = {}
	data.start = owner:GetShootPos()
	data.endpos = data.start + owner:GetAimVector() * 32768
	data.filter = {owner, self}
	local trace = util.TraceLine(data)
	local actions = self:GetActions()
	local action = actions[self.actNum]
	local partString = self.partString or "Body"
	if not action then return end
	local weapon = action.weapon
	if SERVER and trace.Hit then
		local attacker = self:getNetVar("selected", owner)
		if not IsValid(attacker) then
			self:selectTarget()
			attacker = owner
		end

		local actionTbl = {}
		if action.uid then actionTbl = table.Copy(ACTS.actions[action.uid]) end
		local actionInterrupt = hook.Run("nut_ActionInterrupt", action, attacker)
		if actionInterrupt then
			owner:notify(actionInterrupt)
			return
		end

		if not action.attackOverwrite and not actionTbl.attackOverwrite then
			local atk = {
				attacker = attacker,
				trace = trace,
				partString = partString,
				weapon = weapon,
				action = action,
				actionTbl = actionTbl,
			}
			local plugin = combatPlugin()
			if plugin then plugin:attackStart(owner, atk) end
		else
			actionTbl:attackOverwrite(attacker, trace, partString, weapon)
		end

		if attacker.combat then
			attacker:Attack(trace.Entity, actionTbl)
		end

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local owner = self:GetOwner()
		local data = {}
		data.start = owner:GetShootPos()
		data.endpos = data.start + owner:GetAimVector() * 4096
		data.filter = {owner, self}
		local trace = util.TraceLine(data)
		if trace.Hit then
			local entity = trace.Entity
			if IsValid(entity) and (owner:IsAdmin() or (entity.combat and entity:GetCreator() == owner)) then
				self:selectTarget(entity)
			else
				self:selectTarget()
			end
		end
	end
end

-- Server-side: run the same attack pipeline as PrimaryAttack but against a
-- target chosen via V.A.T.S. on the client (instead of trace.Entity from the
-- player's current aim). Synthesises a trace pointing at the target's centre
-- so downstream hooks that read trace.Entity / HitPos still work.
function SWEP:VATSExecuteAttack(targetEnt, partString, actNum)
	if CLIENT then return end
	if not IsValid(targetEnt) then return end
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	local actions = self:GetActions()
	local action = actions and actions[actNum or self.actNum or 1]
	if not action then return end

	local attacker = self:getNetVar("selected", owner)
	if not IsValid(attacker) then attacker = owner end

	local actionTbl = {}
	if action.uid then actionTbl = table.Copy(ACTS.actions[action.uid]) end
	local actionInterrupt = hook.Run("nut_ActionInterrupt", action, attacker)
	if actionInterrupt then
		owner:notify(actionInterrupt)
		return
	end

	local center = targetEnt:WorldSpaceCenter()
	local start = owner:GetShootPos()
	local trace = {
		Entity   = targetEnt,
		HitPos   = center,
		StartPos = start,
		Hit      = true,
		HitGroup = HITGROUP_GENERIC,
		Normal   = (center - start):GetNormalized(),
	}

	if not action.attackOverwrite and not actionTbl.attackOverwrite then
		local atk = {
			attacker = attacker,
			trace = trace,
			partString = partString or "Body",
			weapon = action.weapon,
			action = action,
			actionTbl = actionTbl,
		}
		local plugin = combatPlugin()
		if plugin then plugin:attackStart(owner, atk) end
	else
		actionTbl:attackOverwrite(attacker, trace, partString or "Body", action.weapon)
	end

	if attacker.combat then
		attacker:Attack(targetEnt, actionTbl)
	end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

-- Fallout terminal palette: black phosphor screen with bright green text.
local TERM_BG     = Color(2, 14, 4, 235)
local TERM_DIM    = Color(0, 70, 12, 220)
local TERM_GREEN  = Color(203, 255, 211, 235)
local TERM_BRIGHT = Color(130, 255, 150, 255)
local TERM_DANGER = Color(255, 96, 96, 235)
local TERM_SCAN   = Color(0, 0, 0, 70)

-- V.A.T.S. body-part mapping: trace.HitGroup -> partString understood by sh_parts.lua
local HITGROUP_TO_PART = {
	[HITGROUP_HEAD] = "Head",
	[HITGROUP_CHEST] = "Body",
	[HITGROUP_STOMACH] = "Body",
	[HITGROUP_LEFTARM] = "Left Arm",
	[HITGROUP_RIGHTARM] = "Right Arm",
	[HITGROUP_LEFTLEG] = "Left Leg",
	[HITGROUP_RIGHTLEG] = "Right Leg",
	[HITGROUP_GEAR] = "Body",
	[HITGROUP_GENERIC] = "Body",
}

-- Best-effort bone lookup per part for V.A.T.S. reticles. Uses ValveBiped where
-- present and falls back to the entity's centre when bones are missing.
local PART_BONES = {
	["Head"]      = {"ValveBiped.Bip01_Head1", "bip_head"},
	["Body"]      = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine", "bip_spine_2"},
	["Left Arm"]  = {"ValveBiped.Bip01_L_UpperArm", "bip_upperArm_L"},
	["Right Arm"] = {"ValveBiped.Bip01_R_UpperArm", "bip_upperArm_R"},
	["Left Leg"]  = {"ValveBiped.Bip01_L_Thigh", "bip_hip_L"},
	["Right Leg"] = {"ValveBiped.Bip01_R_Thigh", "bip_hip_R"},
}

local PART_LABEL = {
	["Head"]      = "HEAD",
	["Body"]      = "TORSO",
	["Left Arm"]  = "L.ARM",
	["Right Arm"] = "R.ARM",
	["Left Leg"]  = "L.LEG",
	["Right Leg"] = "R.LEG",
}


local function getPartBonePos(ent, part)
	local names = PART_BONES[part]
	if not names then return ent:WorldSpaceCenter() end
	for _, n in ipairs(names) do
		local id = ent:LookupBone(n)
		if id then
			local pos = ent:GetBonePosition(id)
			if pos and pos ~= vector_origin then return pos end
		end
	end
	return ent:WorldSpaceCenter()
end

-- Closest-bone fallback for HitGroup detection. Source returns HITGROUP_GENERIC
-- for models without hitboxes; when that happens we map the trace HitPos to the
-- nearest known part bone instead, so limb targeting still works on models
-- that lack a proper hitbox set.
local function partFromHitPos(ent, hitPos)
	if not hitPos then return "Body" end
	local best, bestDist = "Body", math.huge
	for partName in pairs(PART_BONES) do
		local pos = getPartBonePos(ent, partName)
		if pos then
			local d = hitPos:DistToSqr(pos)
			if d < bestDist then
				bestDist = d
				best = partName
			end
		end
	end
	return best
end

-- Fallout 4 V.A.T.S. hit-chance chip: a small dark-green box with bracket
-- corners and the percentage centred inside. Returns the chip's bounding box
-- (x, y, w, h) so callers can stack additional labels under the active part.
local function drawVatsChip(cx, cy, text, col, thick)
	surface.SetFont("nutCombatHUD")
	local tw, th = surface.GetTextSize(text)
	local padX, padY = 8, 2
	local w, h = tw + padX * 2, th + padY * 2
	local x, y = math.Round(cx - w * 0.5), math.Round(cy - h * 0.5)
	-- background fill (tracks the pipboy tint via TERM_BG)
	surface.SetDrawColor(TERM_BG.r, TERM_BG.g, TERM_BG.b, 220)
	surface.DrawRect(x, y, w, h)
	-- bracket corners only (Fallout 4 chip look — no full border)
	surface.SetDrawColor(col)
	local c = 5
	thick = thick or 2
	for t = 0, thick - 1 do
		surface.DrawLine(x + t,         y + t,         x + t + c,     y + t)
		surface.DrawLine(x + t,         y + t,         x + t,         y + t + c)
		surface.DrawLine(x + w - c - t, y + t,         x + w - t - 1, y + t)
		surface.DrawLine(x + w - t - 1, y + t,         x + w - t - 1, y + t + c)
		surface.DrawLine(x + t,         y + h - t - 1, x + t + c,     y + h - t - 1)
		surface.DrawLine(x + t,         y + h - c - t, x + t,         y + h - t - 1)
		surface.DrawLine(x + w - c - t, y + h - t - 1, x + w - t - 1, y + h - t - 1)
		surface.DrawLine(x + w - t - 1, y + h - c - t, x + w - t - 1, y + h - t - 1)
	end
	surface.SetTextColor(col)
	surface.SetTextPos(x + padX, y + padY)
	surface.DrawText(text)
	return x, y, w, h
end

local function drawTermPanel(x, y, w, h, title)
	surface.SetDrawColor(TERM_BG)
	surface.DrawRect(x, y, w, h)
	surface.SetDrawColor(TERM_SCAN)
	for sy = y + 1, y + h - 2, 3 do
		surface.DrawLine(x + 1, sy, x + w - 2, sy)
	end
	surface.SetDrawColor(TERM_GREEN)
	surface.DrawOutlinedRect(x, y, w, h, 1)
	surface.SetDrawColor(TERM_DIM)
	surface.DrawOutlinedRect(x + 2, y + 2, w - 4, h - 4, 1)
	local c = 7
	surface.SetDrawColor(TERM_BRIGHT)
	surface.DrawLine(x, y, x + c, y);              surface.DrawLine(x, y, x, y + c)
	surface.DrawLine(x + w - c - 1, y, x + w - 1, y); surface.DrawLine(x + w - 1, y, x + w - 1, y + c)
	surface.DrawLine(x, y + h - 1, x + c, y + h - 1); surface.DrawLine(x, y + h - c - 1, x, y + h - 1)
	surface.DrawLine(x + w - c - 1, y + h - 1, x + w - 1, y + h - 1)
	surface.DrawLine(x + w - 1, y + h - c - 1, x + w - 1, y + h - 1)
	if title then
		surface.SetFont("nutCombatHUD")
		local tx, ty = surface.GetTextSize(title)
		local bw, bh = tx + 14, ty
		local bx = x + (w - bw) * 0.5
		local by = y - bh * 0.5
		surface.SetDrawColor(TERM_GREEN)
		surface.DrawRect(bx, by, bw, bh)
		surface.SetTextColor(0, 16, 4, 255)
		surface.SetTextPos(bx + 7, by)
		surface.DrawText(title)
	end
end

local function drawTermBar(x, y, w, h, perc, label)
	perc = math.Clamp(perc, 0, 1)
	surface.SetDrawColor(TERM_BG)
	surface.DrawRect(x, y, w, h)
	surface.SetDrawColor(TERM_DIM)
	surface.DrawOutlinedRect(x, y, w, h, 1)
	local segs = 20
	local filled = math.floor(perc * segs)
	local segW = (w - 4) / segs
	for i = 0, segs - 1 do
		local sx = x + 2 + i * segW
		surface.SetDrawColor(i < filled and TERM_GREEN or TERM_SCAN)
		surface.DrawRect(sx + 1, y + 2, segW - 2, h - 4)
	end
	if label then
		surface.SetFont("nutCombatHUD")
		local tx, ty = surface.GetTextSize(label)
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(x + w * 0.5 - tx * 0.5, y + h * 0.5 - ty * 0.5)
		surface.DrawText(label)
	end
end

function SWEP:DrawHUD()
	if not CLIENT then return end

	-- Re-tint the V.A.T.S. palette from the shared pipboy primary every frame
	-- so the overlay matches the rest of the pipboy-styled UI (FO3 bracket HUD,
	-- notify panel, combat HUD theme). CYR_GetHUDColor lives in cl_hud_interface
	-- and falls back to `pip_color` / the `fallout_hud_color` convar.
	-- TERM_DANGER and TERM_SCAN stay constant (universal red / scanline).
	-- We mutate the existing Color tables in place because drawTermPanel /
	-- drawTermBar / drawVatsChip captured them as upvalues at file load.
	local primary
	if CYR_GetHUDColor then
		primary = CYR_GetHUDColor()
	elseif pip_color then
		primary = pip_color
	else
		primary = Color(255, 182, 66)  -- FO4 amber fallback
	end
	TERM_BRIGHT.r, TERM_BRIGHT.g, TERM_BRIGHT.b = primary.r, primary.g, primary.b
	TERM_GREEN.r  = math.min(255, primary.r + (255 - primary.r) * 0.4)
	TERM_GREEN.g  = math.min(255, primary.g + (255 - primary.g) * 0.4)
	TERM_GREEN.b  = math.min(255, primary.b + (255 - primary.b) * 0.4)
	TERM_DIM.r    = primary.r * 0.35
	TERM_DIM.g    = primary.g * 0.35
	TERM_DIM.b    = primary.b * 0.35
	TERM_BG.r     = primary.r * 0.04
	TERM_BG.g     = primary.g * 0.04
	TERM_BG.b     = primary.b * 0.04

	local client = LocalPlayer()
	local scrModX = ScrW() / 1920
	local scrModY = ScrH() / 1080
	local actions = self:GetActions() or {}
	local action = actions[self.actNum] or {}

	local user = self:getNetVar("selected", client)
	if not IsValid(user) then
		user = client
	elseif user ~= client then
		local name = self:getNetVar("selectedName", "Unnamed")
		local banner = "// CONTROLLING :: " .. string.upper(name) .. " //"
		surface.SetFont("nutCombatTarget")
		local tw, th = surface.GetTextSize(banner)
		local bx = ScrW() * 0.5 - (tw + 40) * 0.5
		local by = ScrH() * 0.3 - th * 0.5 - 4
		drawTermPanel(bx, by, tw + 40, th + 12)
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(bx + 20, by + 6)
		surface.DrawText(banner)
	end

	local altPressed = client:KeyDown(IN_WALK)
	-- A fresh, filtered TraceLine — GetEyeTrace caches the engine's USE trace
	-- and often reports HitGroup = 0 (generic) for hits that should resolve to
	-- a specific limb. Explicit traceline with MASK_SHOT gives reliable
	-- per-hitbox HitGroup values.
	local trace = util.TraceLine({
		start = client:EyePos(),
		endpos = client:EyePos() + client:GetAimVector() * 32768,
		filter = {client, self},
		mask = MASK_SHOT,
	})
	local entity = trace.Entity

	-- self.viewed gates the action / hit-chance panels: those only make sense
	-- against combat-registered entities or players.
	if (action and action.selfOnly) or altPressed then
		self.viewed = user
	elseif IsValid(entity) and (entity.combat or entity:IsPlayer()) then
		self.viewed = entity
	else
		self.viewed = nil
	end

	-- self.vatsTarget is broader: any aimed entity with a skeleton gets the
	-- per-part hit-chance chips, even if it isn't a combat entity.
	if IsValid(entity) and entity ~= client and entity:GetModel() and entity.LookupBone then
		self.vatsTarget = entity
	else
		self.vatsTarget = nil
	end

	-- V.A.T.S. mode: refresh in-range targets every ~0.4s. Seed the lock-on
	-- to the target nearest the centre of the screen only if we don't have
	-- one yet; after that, mouse flicks (handled in CreateMove) swap it.
	-- Overrides vatsTarget so the existing chip-rendering code paints the
	-- V.A.T.S. selection, and skips trace-based auto-limb (WASD drives it).
	if self.vatsMode then
		if (self.vatsRefreshAt or 0) < CurTime() then
			self:VATSRefreshTargets()
			self.vatsRefreshAt = CurTime() + 0.4
		end
		if not IsValid(self.vatsCommittedTarget) then
			local best, bestDist = nil, math.huge
			local centreX, centreY = ScrW() * 0.5, ScrH() * 0.5
			for _, t in ipairs(self.vatsTargets or {}) do
				if IsValid(t) then
					local sp = t:WorldSpaceCenter():ToScreen()
					if sp.visible then
						local dx, dy = sp.x - centreX, sp.y - centreY
						local d = dx * dx + dy * dy
						if d < bestDist then best, bestDist = t, d end
					end
				end
			end
			self.vatsCommittedTarget = best
		end
		if IsValid(self.vatsCommittedTarget) then
			self.vatsTarget = self.vatsCommittedTarget
			self.viewed = self.vatsCommittedTarget
		end
	elseif IsValid(self.vatsTarget) then
		-- Auto body-part from aim (only when not in V.A.T.S.; in V.A.T.S. the
		-- player picks the limb with WASD).
		local hg = trace.HitGroup or 0
		local part
		if hg ~= HITGROUP_GENERIC and HITGROUP_TO_PART[hg] then
			part = HITGROUP_TO_PART[hg]
		else
			part = partFromHitPos(self.vatsTarget, trace.HitPos)
		end
		if part ~= self.partString then
			self:selectPart(part)
		end
	end

	-- V.A.T.S. overlay: dim screen, label every in-range target above its
	-- centre-of-mass, and put a "V.A.T.S. ENGAGED" banner at the top. Drawn
	-- before the rest of the HUD so chips / panels stack on top.
	--
	-- Wrapped in pcall so any error here can't take down the rest of the
	-- HUD. Errors print to console (rate-limited) so we still see them while
	-- debugging.
	if self.vatsMode then
		local ok, err = pcall(function()
			surface.SetDrawColor(0, 8, 4, 140)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			surface.SetFont("nutCombatTarget")
			local banner = "// V.A.T.S. ENGAGED // [TAB] EXIT  [MOUSE] TARGET  [WASD] LIMB  [LMB] FIRE"
			local tw = surface.GetTextSize(banner)
			surface.SetTextColor(TERM_BRIGHT)
			surface.SetTextPos(ScrW() * 0.5 - tw * 0.5, 14)
			surface.DrawText(banner)

			surface.SetFont("nutCombatHUD")
			for _, t in ipairs(self.vatsTargets or {}) do
				if IsValid(t) then
					local sp = t:WorldSpaceCenter():ToScreen()
					if sp.visible then
						local active = (t == self.vatsCommittedTarget)
						local name = t.Name and t:Name() or t:GetClass()
						local lw, lh = surface.GetTextSize(name)
						local col = active and TERM_BRIGHT or TERM_DIM
						surface.SetTextColor(col)
						surface.SetTextPos(sp.x - lw * 0.5, sp.y - 64)
						surface.DrawText(name)
						-- bracket prefix on the active one
						if active then
							surface.SetDrawColor(TERM_BRIGHT)
							surface.DrawLine(sp.x - lw * 0.5 - 8, sp.y - 64 + lh * 0.5,
							                 sp.x - lw * 0.5 - 2, sp.y - 64 + lh * 0.5)
							surface.DrawLine(sp.x + lw * 0.5 + 2, sp.y - 64 + lh * 0.5,
							                 sp.x + lw * 0.5 + 8, sp.y - 64 + lh * 0.5)
						end
					end
				end
			end
		end)
		if not ok and (self.vatsErrLastT or 0) < CurTime() then
			self.vatsErrLastT = CurTime() + 2
			print("[VATS overlay] " .. tostring(err))
		end
	end

	if action then
		if action.radius then
			client.ccAreaShow = {self.viewed and self.viewed:GetPos() or trace.HitPos, action.radius}
		else
			client.ccAreaShow = nil
		end
	else
		client.ccAreaShow = nil
	end

	surface.SetFont("nutCombatHUD")
	local _, lineH = surface.GetTextSize("M")
	local pad = math.Round(8 * scrModY)

	local APCircle = client:getNetVar("showAPCircle")
	local turnOver = client:getNetVar("turnOverIcon")
	local posX, posY
	if APCircle or turnOver then
		local turnState = turnOver and "TURN OVER" or "YOUR TURN"
		local boxX = 220 * scrModX
		local boxH = lineH + pad * 2
		posX = ScrW() * 0.5 - boxX * 0.5
		posY = 70 * scrModY
		drawTermPanel(posX, posY, boxX, boxH, "STATUS")
		local tx, ty = surface.GetTextSize(turnState)
		surface.SetTextColor(turnOver and TERM_DANGER or TERM_BRIGHT)
		surface.SetTextPos(posX + boxX * 0.5 - tx * 0.5, posY + boxH * 0.5 - ty * 0.5)
		surface.DrawText(turnState)
	end

	-- selected-action indicator (R opens the full picker)
	if actions and #actions > 0 then
		local cur = self.actNum or 1
		local actName = action.name or (actions[cur] and actions[cur].name) or "None"
		local indicator = string.format("[ %s ]  %d/%d  [R] CHANGE", string.upper(actName), cur, #actions)
		surface.SetFont("nutCombatHUD")
		local tw, th = surface.GetTextSize(indicator)
		local boxW = tw + pad * 4
		local boxH = th + pad * 2
		local boxX = ScrW() * 0.5 - boxW * 0.5
		local boxY = ScrH() * 0.55
		drawTermPanel(boxX, boxY, boxW, boxH, "ACTION")
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(boxX + pad * 2, boxY + pad)
		surface.DrawText(indicator)
	end

	local AP = (user.getAP and user:getAP()) or 0
	local APMax = (user.getAPMax and user:getAPMax()) or 0
	local rightX = ScrW() - 240 * scrModX
	local rightW = 220 * scrModX
	posY = 50 * scrModY
	if AP and APMax then
		local boxH = lineH * 2 + pad * 3
		drawTermPanel(rightX, posY, rightW, boxH, "ACTION POINTS")
		local apString = string.format("%d / %d", AP, APMax)
		local tx = surface.GetTextSize(apString)
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(rightX + rightW * 0.5 - tx * 0.5, posY + pad)
		surface.DrawText(apString)
		drawTermBar(rightX + pad, posY + pad * 2 + lineH, rightW - pad * 2, lineH * 0.7, APMax > 0 and AP / APMax or 0)
		posY = posY + boxH + pad
	end

	local buffs = user.getBuffs and user:getBuffs()
	if buffs and table.Count(buffs) > 0 then
		local count = table.Count(buffs)
		local boxH = pad * 2 + lineH * count
		drawTermPanel(rightX, posY, rightW, boxH, "ACTIVE EFFECTS")
		local lineY = posY + pad
		for _, v in pairs(buffs) do
			if v.name then
				local nameDur = "> " .. v.name .. ((v.duration and (" [" .. v.duration .. "T]")) or "")
				surface.SetTextColor(TERM_GREEN)
				surface.SetTextPos(rightX + pad, lineY)
				surface.DrawText(nameDur)
				lineY = lineY + lineH
			end
		end
		posY = posY + boxH + pad
	end

	local cooldowns = user.getCooldowns and user:getCooldowns()
	if cooldowns and table.Count(cooldowns) > 0 then
		local count = table.Count(cooldowns)
		local boxH = pad * 2 + lineH * count
		drawTermPanel(rightX, posY, rightW, boxH, "COOLDOWNS")
		local lineY = posY + pad
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
				local nameDur = "> " .. (actionTbl.name or "Unknown") .. " [" .. (v.duration or 0) .. "T]"
				surface.SetTextColor(TERM_DIM.r + 100, TERM_DIM.g + 80, TERM_DIM.b + 60, 235)
				surface.SetTextPos(rightX + pad, lineY)
				surface.DrawText(nameDur)
				lineY = lineY + lineH
			end
		end
		posY = posY + boxH + pad
	end

	local weapon = action.weapon
	local weaponItem = weapon and nut.item.instances[weapon]
	if weaponItem and weaponItem.magSize then
		local magSize = weaponItem:getData("magSize", weaponItem.magSize)
		local ammo = weaponItem:getData("currentMag", {})
		local _, ammoAmt = ammo[1], ammo[2]
		if not ammoAmt then ammoAmt = 0 end
		local ammoString = string.format("AMMO: %d / %d", ammoAmt, magSize)
		local ammoW = 220 * scrModX
		local ammoH = lineH + pad * 2
		local ammoX = ScrW() - ammoW - 24 * scrModX
		local ammoY = ScrH() - ammoH - 24 * scrModY
		drawTermPanel(ammoX, ammoY, ammoW, ammoH)
		local tx, ty = surface.GetTextSize(ammoString)
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(ammoX + ammoW * 0.5 - tx * 0.5, ammoY + ammoH * 0.5 - ty * 0.5)
		surface.DrawText(ammoString)
	end

	-- V.A.T.S. body-part chips: a small bracketed hit-% chip floats over every
	-- limb on the aimed entity. The active part gets a bold inverted label
	-- stacked on top of it (mirrors the FO4 V.A.T.S. screenshot). Hit chance
	-- is computed per-part by feeding the simulator a fresh info table for
	-- each candidate partString — relies on the combat plugin's
	-- nut_ActionAttackData hook to apply that part's accuracy modifier.
	--
	-- pcall wrap: anything in here that errors gets logged once every 2s
	-- instead of killing the rest of the HUD.
	local _chipsOk, _chipsErr = pcall(function()
	if IsValid(self.vatsTarget) then
		local activePart = self.partString or "Body"
		local plugin = combatPlugin()
		local hasAction = action and action.name
		for partName in pairs(PART_BONES) do
			local pos = getPartBonePos(self.vatsTarget, partName)
			if pos then
				local sp = pos:ToScreen()
				if sp.visible then
					local isActive = partName == activePart
					local col = isActive and TERM_BRIGHT or TERM_GREEN

					-- per-part hit chance (best-effort: needs an action + plugin).
					-- Wrapped in pcall so a single bad part can't take down the
					-- whole VATS overlay if the simulator errors on it.
					local chipText = "--"
					if plugin and hasAction and IsValid(self.viewed) then
						local ok, chance = pcall(function()
							local sim = plugin:attackSimulated(user, {self.viewed}, {
								attacker = user,
								trace = trace,
								partString = partName,
								weapon = action.weapon,
								action = action,
								actionTbl = ACTS.actions[action.uid] or {},
							})
							local acc = (sim.damage and sim.damage[1] and sim.damage[1].accuracy) or 0
							return math.floor(plugin:calcHitChance(acc, self.viewed, user) or 0)
						end)
						if ok then chipText = chance .. "%" end
					end

					local _, cy = drawVatsChip(sp.x, sp.y, chipText, col, isActive and 2 or 1)
					if isActive then
						-- inverted label chip above the percentage, FO4 style
						local label = (PART_LABEL[partName] or partName):upper()
						surface.SetFont("nutCombatHUD")
						local tw, th = surface.GetTextSize(label)
						local lw, lh = tw + 14, th + 2
						local lx = math.Round(sp.x - lw * 0.5)
						local ly = cy - lh - 2
						surface.SetDrawColor(TERM_BRIGHT)
						surface.DrawRect(lx, ly, lw, lh)
						surface.SetTextColor(2, 14, 4, 255)
						surface.SetTextPos(lx + 7, ly + 1)
						surface.DrawText(label)
					end
				end
			end
		end
	end
	end)
	if not _chipsOk and (self.vatsChipErrT or 0) < CurTime() then
		self.vatsChipErrT = CurTime() + 2
		print("[VATS chips] " .. tostring(_chipsErr))
	end

	-- Action / hit-chance info panel: only when aiming at a combat entity or
	-- player (the methods it calls — getHP, attackSimulated, calcHitChance —
	-- assume that surface). Wrapped in pcall — same reason as above.
	local _panelOk, _panelErr = pcall(function()
	if IsValid(self.viewed) and action and action.name then
		local plugin = combatPlugin()
		local name = self.viewed:Name()
		local actionTbl = ACTS.actions[action.uid] or {}
		local part = self.partString or "Body"
		local actWeapon = action.weapon

		local info = {
			attacker = user,
			trace = trace,
			partString = part,
			weapon = actWeapon,
			action = action,
			actionTbl = actionTbl,
		}

		local hitChance = 0
		if plugin then
			local data = plugin:attackSimulated(user, {self.viewed}, info)
			local accuracy = (data.damage and data.damage[1] and data.damage[1].accuracy) or 0
			hitChance = math.floor(plugin:calcHitChance(accuracy, self.viewed, user))
		end

		surface.SetFont("nutCombatHUD")
		local _, targetLineH = surface.GetTextSize("M")

		local lines = {}
		local actionName = action.name or "Unknown Action"
		lines[#lines + 1] = {"> " .. string.upper(actionName) .. " [" .. part .. "]", TERM_BRIGHT}

		if not action.selfOnly then
			local targetHP = self.viewed.getHP and self.viewed:getHP() and tonumber(self.viewed:getHP())
			if targetHP and targetHP <= 0 then
				lines[#lines + 1] = {"TARGET: " .. name .. " :: DECEASED", TERM_DANGER}
			elseif targetHP then
				lines[#lines + 1] = {"TARGET: " .. name .. " :: HP " .. targetHP, TERM_GREEN}
			else
				lines[#lines + 1] = {"TARGET: " .. name, TERM_GREEN}
			end

			local dist = self.viewed:GetPos():Distance(user:GetPos())
			local rangeText = plugin and plugin:DistanceToRange(dist) or nil
			if rangeText then
				lines[#lines + 1] = {"RANGE:  " .. rangeText, TERM_GREEN}
			end

			lines[#lines + 1] = {"CHANCE: " .. hitChance .. "%", hitChance < 30 and TERM_DANGER or TERM_BRIGHT}
		end

		local maxW = 0
		for _, l in ipairs(lines) do
			local lw = surface.GetTextSize(l[1])
			if lw > maxW then maxW = lw end
		end

		local boxW = maxW + pad * 4
		local boxH = #lines * targetLineH + pad * 2
		local boxX = ScrW() * 0.5 - boxW * 0.5
		local boxY = ScrH() * 0.7 - boxH * 0.5
		drawTermPanel(boxX, boxY, boxW, boxH, "TARGET ACQUIRED")
		for i, l in ipairs(lines) do
			surface.SetTextColor(l[2])
			surface.SetTextPos(boxX + pad * 2, boxY + pad + (i - 1) * targetLineH)
			surface.DrawText(l[1])
		end
	end
	end)
	if not _panelOk and (self.vatsPanelErrT or 0) < CurTime() then
		self.vatsPanelErrT = CurTime() + 2
		print("[VATS panel] " .. tostring(_panelErr))
	end
end

function SWEP:Holster(weapon)
	local owner = self:GetOwner()
	if IsValid(owner) then owner.ccAreaShow = nil end
	if CLIENT and self.vatsMode then self:SetVATSMode(false) end
	return true
end

if CLIENT then
	netstream.Hook("CSWep_openActionMenu", function(swep)
		local client = LocalPlayer()
		local actionList = vgui.Create("nutActionList")
		actionList.swep = swep
		actionList.actions = swep:GetActions()
		actionList.selected = swep:getNetVar("selected", client)
	end)

	netstream.Hook("CSWep_loadActions", function(swep, actions) swep.actions = util.JSONToTable(actions) end)

	-- ============================================================== V.A.T.S.
	-- Tab opens a Fallout-style V.A.T.S. overlay: in-range targets light up,
	-- the mouse selects which one to lock on (cursor-closest entity wins),
	-- WASD picks the limb to hit, LMB commits, Tab/RMB cancels. The mode is
	-- pure clientside state — server only sees the eventual CSWep_vatsAttack.

	-- Body parts the player can lock onto in V.A.T.S. Body sits between the
	-- arms and legs in screen space so WASD navigation flows arm→body→leg.
	local VATS_PARTS = {"Head", "Body", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	local VATS_RANGE = 4096
	local VATS_RANGE_SQR = VATS_RANGE * VATS_RANGE

	-- `reason` controls which exit SFX plays when leaving V.A.T.S.:
	--   "commit" → fired the attack, plays ui_vats_exit
	--   anything else (default) → cancelled, plays ui_vats_cancel
	-- ui_vats_camera_in / _out always layer on top of the entry/exit cue.
	function SWEP:SetVATSMode(on, reason)
		on = on and true or false
		if self.vatsMode == on then return end
		self.vatsMode = on
		if on then
			self:VATSRefreshTargets()
			self.vatsMouseAccumX = 0
			self.vatsMouseAccumY = 0
			-- Pre-seed the locked target now (instead of waiting for the
			-- DrawHUD seed) so CalcView has a destination on the very first
			-- frame of the "in" transition. Without this, CalcView returns
			-- nothing until DrawHUD has run at least once, and on lossy
			-- frames the 0.2s timer can elapse before the first zoom frame
			-- ever renders — the camera then snaps straight to the VATS
			-- framing and the user sees no zoom animation at all.
			-- Picks the in-range target nearest screen centre, same scoring
			-- as the DrawHUD seed.
			self.vatsCommittedTarget = nil
			local best, bestDist = nil, math.huge
			local cx, cy = ScrW() * 0.5, ScrH() * 0.5
			for _, t in ipairs(self.vatsTargets or {}) do
				if IsValid(t) then
					local sp = t:WorldSpaceCenter():ToScreen()
					if sp.visible then
						local dx, dy = sp.x - cx, sp.y - cy
						local d = dx * dx + dy * dy
						if d < bestDist then best, bestDist = t, d end
					end
				end
			end
			self.vatsCommittedTarget = best
			-- Kick off the zoom-IN transition. CalcView handles the blend
			-- from the player's normal view → VATS framing, and computes the
			-- duration from camera travel distance (0.2s..0.6s) on its first
			-- frame. We intentionally do NOT pre-seed vatsCamOrigin/Angles/FOV
			-- so the blend starts from the live eye position rather than stale
			-- cached state.
			self.vatsCamPhase         = "in"
			self.vatsCamPhaseStart    = CurTime()
			self.vatsCamTransitionDur = nil
			surface.PlaySound("vats wav files/ui_vats_enter.wav")
			surface.PlaySound("vats wav files/ui_vats_camera_in.wav")
		else
			self.vatsTargets = nil
			self.vatsCommittedTarget = nil
			self.vatsMouseAccumX = 0
			self.vatsMouseAccumY = 0
			self.vatsNextFlickT = nil
			-- Kick off the zoom-OUT transition. CalcView blends FROM the cached
			-- cam state TO the player's normal view (duration 0.2s..0.6s scaled
			-- by camera travel distance, computed lazily on first frame), then
			-- clears the cached state itself — don't clear it here or there's
			-- nothing to lerp from.
			self.vatsCamPhase         = "out"
			self.vatsCamPhaseStart    = CurTime()
			self.vatsCamTransitionDur = nil
			if reason == "commit" then
				surface.PlaySound("vats wav files/ui_vats_exit.wav")
			else
				surface.PlaySound("vats wav files/ui_vats_cancel.wav")
			end
			surface.PlaySound("vats wav files/ui_vats_camera_out.wav")
		end
	end

	-- ──────────────────────────────────────────────────────────────────────
	-- V.A.T.S. WASD limb picker
	-- ──────────────────────────────────────────────────────────────────────
	-- Goal: when the player presses W/A/S/D, hop to the limb that visually
	-- sits in that direction from the currently-selected limb. The picker
	-- works in screen space (not world space) so it stays correct no matter
	-- how the target is oriented — ragdolled, facing away, mid-animation.
	--
	-- Tuning knobs:
	--   VATS_PICK_AXIS_MIN
	--     Minimum projection on the desired axis (px) before a candidate
	--     counts as "in that direction". Filters out jitter when two limbs
	--     sit at near-identical heights/positions. Bump up if diagonal limbs
	--     get picked instead of the obvious axis neighbour.
	--   VATS_PICK_OFFAXIS_BIAS
	--     Weight applied to the perpendicular (off-axis) distance when
	--     scoring candidates. Higher = stronger preference for picking the
	--     limb that's most aligned with the axis (e.g. pressing S from Head
	--     prefers Body, which is directly below, over an arm that's down-and-
	--     to-the-side). 0 = pure-distance behaviour. Try 0.5–2.0.
	--   VATS_PICK_WRAP_ENABLED
	--     If true, pressing a direction with no candidate that way wraps to
	--     the limb farthest in the opposite direction (e.g. D from the right-
	--     most limb jumps to the left-most). Set false for a hard stop.
	local VATS_PICK_AXIS_MIN      = 12
	local VATS_PICK_OFFAXIS_BIAS  = 1.5
	local VATS_PICK_WRAP_ENABLED  = true

	-- Direction key → (primary, perpendicular) extractor. `primary` is signed
	-- so that "further in the requested direction" is more positive; that
	-- lets the same scoring formula handle all four keys.
	local function decomposeDir(dir, dx, dy)
		if     dir == "w" then return -dy, math.abs(dx)
		elseif dir == "s" then return  dy, math.abs(dx)
		elseif dir == "a" then return -dx, math.abs(dy)
		elseif dir == "d" then return  dx, math.abs(dy)
		end
		return 0, 0
	end

	function SWEP:VATSPickNextPart(dir)
		local target = self.vatsCommittedTarget
		if not IsValid(target) then return end

		-- Step 1. Project every selectable part to screen space. Parts whose
		-- bone is off-screen / behind the camera are excluded; they can't be
		-- targets of a directional hop because the player can't see them.
		local positions = {}
		for _, part in ipairs(VATS_PARTS) do
			local pos = getPartBonePos(target, part)
			if pos then
				local sp = pos:ToScreen()
				if sp.visible then
					positions[part] = sp
				end
			end
		end

		-- Step 2. Pick an anchor. Normally that's the currently-selected
		-- limb. If it's off-screen (target turned around, etc.) fall back to
		-- whichever visible limb is nearest screen centre so the picker still
		-- responds to input instead of silently doing nothing.
		local cur = self.partString or "Head"
		local curSp = positions[cur]
		if not curSp then
			local cx, cy = ScrW() * 0.5, ScrH() * 0.5
			local bestPart, bestD = nil, math.huge
			for part, sp in pairs(positions) do
				local d = (sp.x - cx) ^ 2 + (sp.y - cy) ^ 2
				if d < bestD then bestPart, bestD = part, d end
			end
			if not bestPart then return end
			cur, curSp = bestPart, positions[bestPart]
		end

		-- Step 3. Score every other visible part.
		-- For each candidate we compute `primary` (signed advance along the
		-- requested axis) and `perp` (unsigned distance off that axis).
		--   primary >=  AXIS_MIN  →  candidate sits in the requested direction
		--   primary <= -AXIS_MIN  →  candidate sits in the OPPOSITE direction
		--                            (only used if wrap-around is enabled)
		-- The lower the score the better; the formula trades distance
		-- against alignment via OFFAXIS_BIAS.
		local bestInDir,  bestInScore   = nil, math.huge
		local bestWrap,   bestWrapScore = nil, -math.huge
		for part, sp in pairs(positions) do
			if part ~= cur then
				local primary, perp = decomposeDir(dir, sp.x - curSp.x, sp.y - curSp.y)
				if primary >= VATS_PICK_AXIS_MIN then
					-- Lower = closer along axis and closer to centred.
					local score = primary + perp * VATS_PICK_OFFAXIS_BIAS
					if score < bestInScore then
						bestInDir, bestInScore = part, score
					end
				elseif VATS_PICK_WRAP_ENABLED and -primary >= VATS_PICK_AXIS_MIN then
					-- For wrap we want the limb FURTHEST behind us, with
					-- perpendicular offset as a tiebreaker. Encode as a
					-- single descending score so we can compare in one pass:
					-- big opposite distance wins; among ties, smallest perp.
					local score = -primary - perp * VATS_PICK_OFFAXIS_BIAS * 0.5
					if score > bestWrapScore then
						bestWrap, bestWrapScore = part, score
					end
				end
			end
		end

		return bestInDir or bestWrap
	end

	-- Pick the in-range target that best matches a flick direction. We score
	-- each candidate by its alignment with the flick (dot product) and prefer
	-- closer ones (score = dot / distance). Targets behind the flick direction
	-- are ignored.
	--
	-- IMPORTANT: candidates are projected against the player's LOCKED EYE
	-- FRAME (right/up vectors derived from EyeAngles), NOT through :ToScreen()
	-- which would project through the active rendered camera — and that
	-- camera is the VATS cinematic cam. Once we'd switched to a target at
	-- higher elevation or a wide angle, the cinematic cam pivoted, and the
	-- previous target ended up behind it. :ToScreen() then reported it as
	-- non-visible, the candidate loop dropped it, and the player couldn't
	-- flick back. CreateMove freezes mouse input while VATS is engaged, so
	-- EyeAngles stays stable for the whole session — projecting against it
	-- gives consistent flick semantics regardless of where the cinematic cam
	-- has roamed.
	function SWEP:VATSSwitchTargetInDirection(dx, dy)
		local current = self.vatsCommittedTarget
		local ply     = LocalPlayer()
		if not IsValid(ply) then return end
		local eyePos  = ply:EyePos()
		local eyeAng  = ply:EyeAngles()
		local fwd     = eyeAng:Forward()
		local right   = eyeAng:Right()
		local up      = eyeAng:Up()

		-- Reference point: projected coordinates of the current target in the
		-- eye-view plane. Falls back to (0,0) — the player's centre of view —
		-- if there's no current target or it's somehow behind the player.
		local refX, refY = 0, 0
		if IsValid(current) then
			local d = current:WorldSpaceCenter() - eyePos
			if d:Dot(fwd) > 0 then
				refX =  d:Dot(right)
				refY = -d:Dot(up)  -- screen Y is inverted (down = positive)
			end
		end

		local best, bestScore = nil, -math.huge
		for _, t in ipairs(self.vatsTargets or {}) do
			if IsValid(t) and t ~= current then
				local d = t:WorldSpaceCenter() - eyePos
				-- Skip candidates behind the player. Possible since
				-- VATSRefreshTargets only filters by distance, not facing.
				if d:Dot(fwd) > 0 then
					local tx =  d:Dot(right) - refX
					local ty = -d:Dot(up)    - refY
					local mag = math.sqrt(tx * tx + ty * ty)
					if mag > 8 then
						local dot = (tx / mag) * dx + (ty / mag) * dy
						if dot > 0.2 then  -- roughly in the flick direction
							local score = dot / math.max(mag, 1)
							if score > bestScore then
								best, bestScore = t, score
							end
						end
					end
				end
			end
		end
		if IsValid(best) then
			self.vatsCommittedTarget = best
			surface.PlaySound("vats wav files/ui_vats_selecttarget.wav")
		end
	end

	function SWEP:VATSRefreshTargets()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local origin = ply:GetPos()
		local out = {}
		for _, ent in ipairs(ents.GetAll()) do
			if IsValid(ent) and ent ~= ply
				and (ent.combat or ent:IsPlayer())
				and ent:GetPos():DistToSqr(origin) <= VATS_RANGE_SQR then
				out[#out + 1] = ent
			end
		end
		self.vatsTargets = out
	end

	function SWEP:VATSCommit()
		if not self.vatsMode then return end
		local target = self.vatsCommittedTarget
		if not IsValid(target) then return end
		surface.PlaySound("vats wav files/ui_vats_ready.wav")
		netstream.Start(
			"CSWep_vatsAttack",
			target,
			self.partString or "Body",
			self.actNum or 1,
			self)
		self:SetVATSMode(false, "commit")
	end

	local VATS_FLICK_THRESHOLD = 350
	local VATS_FLICK_DEBOUNCE  = 0.2  -- seconds to ignore mouse after a flick fires
	local VATS_KEY_REPEAT      = 0.2  -- seconds between repeated fires while held

	-- Edge-detect: returns true on the tick `cur` first goes from false → true.
	-- State stored on the weapon so it survives across ticks without globals.
	local function pressedEdge(cur, wep, field)
		local prev = wep[field] or false
		wep[field] = cur
		return cur and not prev
	end

	-- Like pressedEdge, but if the key stays held the result fires again every
	-- VATS_KEY_REPEAT seconds. First press is immediate; tapping fast still
	-- produces a fire per tap (release zeroes the prev state).
	local function pressedRepeating(cur, wep, prevField, lastField)
		if not cur then
			wep[prevField] = false
			return false
		end
		local now = CurTime()
		local prev = wep[prevField] or false
		wep[prevField] = true
		if not prev then
			wep[lastField] = now
			return true
		end
		if now - (wep[lastField] or 0) >= VATS_KEY_REPEAT then
			wep[lastField] = now
			return true
		end
		return false
	end

	-- Input *detection* reads the OS keyboard state via input.IsKeyDown /
	-- input.IsMouseDown. Going through this path means no other addon's
	-- PlayerBindPress / CreateMove can swallow the press before we see it.
	-- This Think hook just *triggers* V.A.T.S. actions; suppression of the
	-- corresponding engine input (so the scoreboard doesn't open, the SWEP
	-- doesn't fire, the player doesn't move) is handled in CreateMove below.
	hook.Add("Think", "nut_cswep_vats_input", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "nut_cswep" then return end

		-- Tab toggles V.A.T.S. either way. Toggling off counts as a cancel
		-- so the cancel SFX plays instead of the commit/exit SFX.
		if pressedEdge(input.IsKeyDown(KEY_TAB), wep, "vatsPrevTab") then
			if wep.vatsMode then
				wep:SetVATSMode(false, "cancel")
			else
				wep:SetVATSMode(true)
			end
		end

		if not wep.vatsMode then return end

		-- WASD limb picker. The picker reads the current screen positions of
		-- each selectable limb so the direction tracks what the player sees
		-- (handles viewing from behind, ragdolls, etc.) and wraps around.
		-- Uses pressedRepeating so a held key cycles at VATS_KEY_REPEAT (0.2s),
		-- with the first press firing immediately.
		local dir
		if     pressedRepeating(input.IsKeyDown(KEY_W), wep, "vatsPrevW", "vatsLastW") then dir = "w"
		elseif pressedRepeating(input.IsKeyDown(KEY_S), wep, "vatsPrevS", "vatsLastS") then dir = "s"
		elseif pressedRepeating(input.IsKeyDown(KEY_A), wep, "vatsPrevA", "vatsLastA") then dir = "a"
		elseif pressedRepeating(input.IsKeyDown(KEY_D), wep, "vatsPrevD", "vatsLastD") then dir = "d"
		end
		if dir then
			local nextPart = wep:VATSPickNextPart(dir)
			if nextPart and nextPart ~= wep.partString then
				wep:selectPart(nextPart)
				surface.PlaySound("vats wav files/ui_vats_selecttargetpart.wav")
			end
		end

		-- LMB commits, RMB cancels — but only when no Derma popup has the
		-- cursor. input.IsMouseDown reads raw OS state, so clicking on the
		-- action-list buttons would otherwise be caught here as a VATS
		-- commit/cancel and either fire the attack or exit V.A.T.S. mid-
		-- selection. While the cursor is visible we still resync the
		-- prev-state fields with the current button state so that closing
		-- the popup doesn't manufacture a fake edge on the next tick
		-- (e.g. if the player let go of LMB while the popup was open, we
		-- don't want the very next mouse-up→mouse-down to fire commit).
		if vgui.CursorVisible() then
			wep.vatsPrevLMB = input.IsMouseDown(MOUSE_LEFT)
			wep.vatsPrevRMB = input.IsMouseDown(MOUSE_RIGHT)
		else
			if pressedEdge(input.IsMouseDown(MOUSE_LEFT),  wep, "vatsPrevLMB") then
				wep:VATSCommit()
			end
			if pressedEdge(input.IsMouseDown(MOUSE_RIGHT), wep, "vatsPrevRMB") then
				wep:SetVATSMode(false, "cancel")
			end
		end
	end)

	-- CreateMove handles *suppression*: stripping IN_* bits so the engine
	-- doesn't open the scoreboard, fire the weapon, or move the player,
	-- and accumulating the raw mouse delta for the target flick. Even if
	-- another addon's Think/PlayerBindPress hijacks bind names, this still
	-- runs as long as no one strips us *upstream* — and since we don't read
	-- presses here anymore, an upstream cmd:RemoveKey doesn't break us.
	hook.Add("CreateMove", "nut_cswep_vats_freeze", function(cmd)
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "nut_cswep" then return end

		-- Always swallow Tab while holding the combat SWEP — it's ours.
		cmd:RemoveKey(IN_SCORE)

		if not wep.vatsMode then return end

		-- Block firing/secondary while V.A.T.S. is active.
		cmd:RemoveKey(IN_ATTACK)
		cmd:RemoveKey(IN_ATTACK2)

		-- Mouse flick: accumulate cmd delta until magnitude crosses
		-- threshold, then resolve to a direction and switch target.
		-- After a flick fires we hold a VATS_FLICK_DEBOUNCE cooldown and
		-- zero the accumulator each tick so a continuous mouse sweep can't
		-- rapid-cycle through targets.
		local mx, my = cmd:GetMouseX(), cmd:GetMouseY()
		if (wep.vatsNextFlickT or 0) > CurTime() then
			wep.vatsMouseAccumX = 0
			wep.vatsMouseAccumY = 0
		else
			local ax = (wep.vatsMouseAccumX or 0) + mx
			local ay = (wep.vatsMouseAccumY or 0) + my
			local mag = math.sqrt(ax * ax + ay * ay)
			if mag >= VATS_FLICK_THRESHOLD then
				wep:VATSSwitchTargetInDirection(ax / mag, ay / mag)
				wep.vatsMouseAccumX = 0
				wep.vatsMouseAccumY = 0
				wep.vatsNextFlickT = CurTime() + VATS_FLICK_DEBOUNCE
			else
				wep.vatsMouseAccumX = ax
				wep.vatsMouseAccumY = ay
			end
		end

		-- Freeze the player in place and lock the view.
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
		cmd:SetUpMove(0)
		cmd:SetMouseX(0)
		cmd:SetMouseY(0)
	end)

	-- Block the scoreboard while the combat SWEP is the active weapon. The
	-- CreateMove hook above strips IN_SCORE from the user command, but the
	-- client-side scoreboard is opened by the GM:ScoreboardShow hook which
	-- fires locally before any usercmd is sent — without this, pressing Tab
	-- to toggle V.A.T.S. would also pop the scoreboard each time. Returning
	-- false here suppresses the panel; other gamemodes / hooks see no change
	-- when the player isn't holding nut_cswep.
	hook.Add("ScoreboardShow", "nut_cswep_block_score", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == "nut_cswep" then
			return false
		end
	end)

	-- Backup: bind any key to "nut_vats_toggle" if Tab is still being
	-- swallowed by something weird (e.g. `bind v nut_vats_toggle`).
	concommand.Add("nut_vats_toggle", function()
		local wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == "nut_cswep" and wep.SetVATSMode then
			wep:SetVATSMode(not wep.vatsMode)
		end
	end)

	-- Zoom camera while V.A.T.S. is active: frame the active limb at a fixed
	-- distance along the player→target line, with a narrower FOV so other
	-- limbs are still visible at the edges. Origin/angles/FOV are lerped each
	-- frame so target/limb changes pan smoothly rather than snapping.
	local VATS_CAM_DIST = 120   -- units from active part along player→target ray
	local VATS_CAM_FOV  = 55    -- narrower than the default 75 for a slight zoom
	local VATS_CAM_LERP = 10    -- inter-limb lerp rate (1/s); bigger = snappier

	-- Enter/exit zoom duration scales with how far the camera has to travel.
	-- A close-range engagement keeps the snappy 0.2s feel; a target across a
	-- room or at a wildly different elevation gets more time so the motion
	-- doesn't feel hurled. Capped so very long shots never go sluggish.
	local VATS_TRANSITION_MIN   = 0.2     -- floor for any transition
	local VATS_TRANSITION_MAX   = 0.6     -- ceiling, regardless of distance
	local VATS_TRANSITION_SCALE = 1/2500  -- seconds added per unit of cam travel
	local function vatsDuration(camTravel)
		return math.Clamp(VATS_TRANSITION_MIN + (camTravel or 0) * VATS_TRANSITION_SCALE,
		                  VATS_TRANSITION_MIN, VATS_TRANSITION_MAX)
	end

	-- Perlin's smootherstep: maps linear progress t∈[0,1] to an eased value
	-- with zero velocity AND zero acceleration at both endpoints. Softens the
	-- enter/exit zoom so the camera doesn't pop at start/end.
	local function vatsEase(t)
		t = math.Clamp(t, 0, 1)
		return t * t * t * (t * (t * 6 - 15) + 10)
	end

	-- vatsCamPhase semantics:
	--   "in"   → blending FROM player's eye view TO VATS framing  (0.2s)
	--   nil + vatsMode=true  → active VATS, per-frame inter-limb lerp
	--   "out"  → blending FROM cached VATS view BACK to player's eye view (0.2s)
	-- vatsCamPhaseStart is the CurTime() at which the current transition began.
	hook.Add("CalcView", "nut_cswep_vats_view", function(ply, origin, angles, fov)
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "nut_cswep" then return end

		local active = wep.vatsMode
		local phase  = wep.vatsCamPhase
		if not active and phase ~= "out" then return end

		-- Compute the VATS framing for the currently-locked target+limb (if any).
		-- Used as the destination for "in", as the per-frame target for active,
		-- and as a refresh source if "out" still has a valid target.
		local desiredOrigin, desiredAngles, desiredFOV
		local target = wep.vatsCommittedTarget
		if IsValid(target) then
			local partPos = getPartBonePos(target, wep.partString or "Head")
			if partPos then
				local toPart = partPos - origin
				local dist = toPart:Length()
				if dist >= 1 then
					local dir = toPart / dist
					desiredOrigin = partPos - dir * VATS_CAM_DIST
					desiredAngles = dir:Angle()
					desiredFOV    = VATS_CAM_FOV
				end
			end
		end

		-- ── "in" phase: timed blend from player's live eye view → VATS view.
		if phase == "in" then
			-- No target yet → no destination to blend toward. Let the frame
			-- render at the normal view; the timer keeps ticking so if a
			-- target appears mid-window we still get a partial blend (and
			-- if it appears after the window, we snap which is fine).
			if not desiredOrigin then return end
			-- Compute the per-transition duration once, the first frame we
			-- have a destination. Based on the world-space distance the
			-- camera has to travel from the player's eye to the VATS frame.
			if not wep.vatsCamTransitionDur then
				wep.vatsCamTransitionDur = vatsDuration((desiredOrigin - origin):Length())
			end
			local raw = (CurTime() - (wep.vatsCamPhaseStart or 0)) / wep.vatsCamTransitionDur
			if raw >= 1 then
				wep.vatsCamPhase         = nil
				wep.vatsCamPhaseStart    = nil
				wep.vatsCamTransitionDur = nil
				wep.vatsCamOrigin        = desiredOrigin
				wep.vatsCamAngles        = desiredAngles
				wep.vatsCamFOV           = desiredFOV
				return { origin = desiredOrigin, angles = desiredAngles, fov = desiredFOV, drawviewer = true }
			end
			local frac = vatsEase(raw)
			local o = LerpVector(frac, origin, desiredOrigin)
			local a = LerpAngle (frac, angles, desiredAngles)
			local f = Lerp     (frac, fov,    desiredFOV)
			-- Cache the in-progress blend so an "out" interrupting an "in"
			-- has a usable lerp-from point instead of a hard snap.
			wep.vatsCamOrigin, wep.vatsCamAngles, wep.vatsCamFOV = o, a, f
			return { origin = o, angles = a, fov = f, drawviewer = true }
		end

		-- ── "out" phase: timed blend from cached VATS view → player's eye.
		if phase == "out" then
			local fromO, fromA, fromF = wep.vatsCamOrigin, wep.vatsCamAngles, wep.vatsCamFOV
			-- Nothing cached (e.g. exited VATS before any target ever locked):
			-- release immediately and let the default view take over.
			if not fromO then
				wep.vatsCamPhase, wep.vatsCamPhaseStart = nil, nil
				return
			end
			-- Duration scales with how far the camera has to travel back to
			-- the player's eye. Computed once on the first frame of the phase.
			if not wep.vatsCamTransitionDur then
				wep.vatsCamTransitionDur = vatsDuration((origin - fromO):Length())
			end
			local raw = (CurTime() - (wep.vatsCamPhaseStart or 0)) / wep.vatsCamTransitionDur
			if raw >= 1 then
				wep.vatsCamPhase, wep.vatsCamPhaseStart = nil, nil
				wep.vatsCamTransitionDur = nil
				wep.vatsCamOrigin, wep.vatsCamAngles, wep.vatsCamFOV = nil, nil, nil
				return
			end
			local frac = vatsEase(raw)
			return {
				origin     = LerpVector(frac, fromO, origin),
				angles     = LerpAngle (frac, fromA, angles),
				fov        = Lerp     (frac, fromF, fov),
				drawviewer = true,
			}
		end

		-- ── Active VATS, no transition: existing per-frame inter-limb lerp.
		if not desiredOrigin then return end
		wep.vatsCamOrigin = wep.vatsCamOrigin or desiredOrigin
		wep.vatsCamAngles = wep.vatsCamAngles or desiredAngles
		wep.vatsCamFOV    = wep.vatsCamFOV    or desiredFOV
		local frac = math.Clamp(FrameTime() * VATS_CAM_LERP, 0, 1)
		wep.vatsCamOrigin = LerpVector(frac, wep.vatsCamOrigin, desiredOrigin)
		wep.vatsCamAngles = LerpAngle (frac, wep.vatsCamAngles, desiredAngles)
		wep.vatsCamFOV    = Lerp     (frac, wep.vatsCamFOV,    desiredFOV)

		return {
			origin     = wep.vatsCamOrigin,
			angles     = wep.vatsCamAngles,
			fov        = wep.vatsCamFOV,
			drawviewer = true,  -- show the player's body since the cam is offset
		}
	end)

	-- Cached colour-modify material for the VATS desaturation pass. Drawn
	-- as a fullscreen quad sampling the current scene texture, with
	-- $pp_colour_colour controlling saturation (1 = original colour,
	-- 0 = fully grayscale). Cached at module level so we don't churn a new
	-- material instance every frame.
	local NUT_VATS_DESAT_MAT = Material("pp/colour")

	-- World desaturation while V.A.T.S. is engaged. Everything (world, props,
	-- the player's own body, other characters) drops to grayscale except the
	-- locked target, which keeps full colour — mirrors the FO4 VATS
	-- highlight. The effect fades in/out alongside the camera transition.
	--
	-- Runs in PostDrawTranslucentRenderables (NOT RenderScreenspaceEffects).
	-- By the time RSE fires the engine has often swapped the active render
	-- target to a stencil-less scene copy for post effects — every stencil
	-- op becomes a no-op there, which made both write and test trivially
	-- pass and the desat bled over the target. PDTR runs inside the main 3D
	-- pass while the framebuffer (with stencil) is still bound, and is the
	-- hook the canonical GMod halo library uses for exactly this pattern.
	hook.Add("PostDrawTranslucentRenderables", "nut_cswep_vats_desat", function(bDepth, bSkybox, bDraw3DSkybox)
		-- Filter out water reflections, depth-only passes, 3D-skybox renders —
		-- this hook fires for each of those and we only want main-view drawing.
		if bDepth or bSkybox or bDraw3DSkybox then return end

		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "nut_cswep" then return end

		local active = wep.vatsMode
		local phase  = wep.vatsCamPhase
		if not active and phase ~= "out" then return end

		-- Strength: 0 = no desat, 1 = fully grayscale. Eased the same way the
		-- camera blend is, so the two changes feel like one motion.
		local dur = wep.vatsCamTransitionDur or VATS_TRANSITION_MIN
		local desat = 1
		if phase == "in" then
			desat = vatsEase((CurTime() - (wep.vatsCamPhaseStart or 0)) / dur)
		elseif phase == "out" then
			desat = 1 - vatsEase((CurTime() - (wep.vatsCamPhaseStart or 0)) / dur)
		end
		if desat <= 0 then return end

		-- Mark target + local player pixels in stencil (ref=1). The exact
		-- pattern the halo library uses: STENCIL_ALWAYS + REPLACE-on-pass +
		-- KEEP-on-fail, with colour writes disabled so the models aren't
		-- repainted on top of the existing scene.
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(0xFF)
		render.SetStencilTestMask(0xFF)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.OverrideColorWriteEnable(true, false)
		ply:DrawModel()
		local target = wep.vatsCommittedTarget
		if IsValid(target) then target:DrawModel() end
		render.OverrideColorWriteEnable(false)

		-- Subsequent draws skip pixels where stencil == 1 (player + target).
		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		-- Fullscreen desaturation pass. Same calls as DrawColorModify but
		-- inlined so we keep the stencil state intact across the texture
		-- snapshot + quad draw (DrawColorModify's internal sequence is
		-- functionally identical, but inlining removes the chance of
		-- some future GMod version slipping a render-state reset into it).
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_addr",       0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_addg",       0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_addb",       0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_brightness", 0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_contrast",   1)
		-- $pp_colour_colour = 1 → full original colour, 0 → fully grayscale.
		-- We floor at 0.1 so the world keeps a faint hint of saturation at
		-- maximum effect rather than going pure black-and-white.
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_colour",     1 - desat * 0.9)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_mulr",       0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_mulg",       0)
		NUT_VATS_DESAT_MAT:SetFloat("$pp_colour_mulb",       0)

		render.UpdateScreenEffectTexture()
		render.SetMaterial(NUT_VATS_DESAT_MAT)
		render.DrawScreenQuad()

		render.SetStencilEnable(false)
	end)
end
