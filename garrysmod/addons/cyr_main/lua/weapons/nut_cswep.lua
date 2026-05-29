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
	["Body"]      = "BODY",
	["Left Arm"]  = "L.ARM",
	["Right Arm"] = "R.ARM",
	["Left Leg"]  = "L.LEG",
	["Right Leg"] = "R.LEG",
}


-- Average a list of bone names into a single world position. Each bone is
-- nudged toward its first child (when one exists) so the aim point lands in
-- the middle of the bone segment rather than at the joint near the torso.
local function averageBonePositions(ent, names)
	if not IsValid(ent) or not names then return nil end
	local sum, count = Vector(0, 0, 0), 0

	-- Build a parent->children map once per call so we can find each bone's
	-- child to compute a midpoint.
	local children
	local function ensureChildren()
		if children then return end
		children = {}
		for i = 0, (ent:GetBoneCount() or 0) - 1 do
			local p = ent:GetBoneParent(i)
			if p and p >= 0 then
				children[p] = children[p] or {}
				table.insert(children[p], i)
			end
		end
	end

	for _, n in ipairs(names) do
		local id = ent:LookupBone(n)
		if id then
			local pos = ent:GetBonePosition(id)
			if not pos or pos == vector_origin then
				local m = ent:GetBoneMatrix(id)
				if m then pos = m:GetTranslation() end
			end
			if pos and pos ~= vector_origin then
				-- Push the sample halfway toward the first child bone so the
				-- effect sits along the limb instead of right at the joint.
				ensureChildren()
				local kids = children[id]
				if kids and kids[1] then
					local cm = ent:GetBoneMatrix(kids[1])
					if cm then
						pos = (pos + cm:GetTranslation()) * 0.5
					end
				end
				sum = sum + pos
				count = count + 1
			end
		end
	end

	if count == 0 then return nil end
	return sum / count
end

local function getPartBonePos(ent, part)
	-- Prefer per-model bones from the CYR CombatModel registry (handles
	-- non-humanoid limbs like Tail/Stinger/Front Left Leg).
	if NWL and NWL.CombatModel and IsValid(ent) then
		local limb = NWL.CombatModel.GetLimb(ent, part)
		if limb and limb.bones then
			local avg = averageBonePositions(ent, limb.bones)
			if avg then return avg end
		end
	end

	local names = PART_BONES[part]
	if not names then
		if IsValid(ent) then return ent:WorldSpaceCenter() end
		return nil
	end
	local avg = averageBonePositions(ent, names)
	if avg then return avg end
	return ent:WorldSpaceCenter()
end

-- Returns the ordered list of part names to consider for this entity:
-- if the CombatModel registry has a set for it, those limb names; else the
-- default 6-part humanoid list.
local function getPartListFor(ent)
	if NWL and NWL.CombatModel and IsValid(ent) then
		local set = NWL.CombatModel.GetLimbSet(ent)
		if set then
			local out = {}
			for name in pairs(set) do out[#out + 1] = name end
			table.sort(out)
			return out
		end
	end
	return {"Head", "Body", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
end

-- Closest-bone fallback for HitGroup detection. Source returns HITGROUP_GENERIC
-- for models without hitboxes; when that happens we map the trace HitPos to the
-- nearest known part bone instead, so limb targeting still works on models
-- that lack a proper hitbox set.
local function partFromHitPos(ent, hitPos)
	if not hitPos then return "Body" end
	local best, bestDist = "Body", math.huge
	for _, partName in ipairs(getPartListFor(ent)) do
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

	-- Hide the combat HUD entirely while the Pip-Boy is raised — it owns the
	-- screen, and V.A.T.S. is forced off under it anyway.
	if PIPBOY_ON_SCREEN then return end

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
			self:VATSSetTarget(best)
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
			local banner = "// V.A.T.S. ENGAGED // [TAB] EXIT  [Q] UNDO  [WASD] TARGET  [0-9]/[ALT+CLICK] PICK  [MOUSE] LIMB  [LMB] FIRE"
			local tw = surface.GetTextSize(banner)
			surface.SetTextColor(TERM_BRIGHT)
			surface.SetTextPos(ScrW() * 0.5 - tw * 0.5, 14)
			surface.DrawText(banner)

			surface.SetFont("nutCombatHUD")
			-- On-screen targets only, numbered nearest-first so labels stay
			-- contiguous ([0],[1],[2]…) and match the number keys. To keep a crowd
			-- from collapsing into an unreadable wall of text, only the ACTIVE
			-- target spells out its name — every other target shows just its
			-- compact [n] chip.
			for i, info in ipairs(self:VATSScreenTargets()) do
				local t = info.ent
				local active = (t == self.vatsCommittedTarget)
				local num = (i <= 10) and ("[" .. (i - 1) .. "]") or nil
				local label
				if active then
					label = (num and (num .. " ") or "") .. (t.Name and t:Name() or t:GetClass())
				else
					label = num or (t.Name and t:Name() or t:GetClass())
				end
				local lw, lh = surface.GetTextSize(label)
				local col = active and TERM_BRIGHT or TERM_DIM
				surface.SetTextColor(col)
				surface.SetTextPos(info.x - lw * 0.5, info.y - 64)
				surface.DrawText(label)
				-- bracket flanks on the active one
				if active then
					surface.SetDrawColor(TERM_BRIGHT)
					surface.DrawLine(info.x - lw * 0.5 - 8, info.y - 64 + lh * 0.5,
					                 info.x - lw * 0.5 - 2, info.y - 64 + lh * 0.5)
					surface.DrawLine(info.x + lw * 0.5 + 2, info.y - 64 + lh * 0.5,
					                 info.x + lw * 0.5 + 8, info.y - 64 + lh * 0.5)
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
		-- Match TARGET ACQUIRED: extra top padding so the header chip doesn't
		-- crowd the indicator line.
		local topPad = pad * 2
		local boxW = tw + pad * 4
		local boxH = th + topPad + pad
		local boxX = ScrW() * 0.5 - boxW * 0.5
		local boxY = ScrH() * 0.55
		drawTermPanel(boxX, boxY, boxW, boxH, "ACTION")
		surface.SetTextColor(TERM_BRIGHT)
		surface.SetTextPos(boxX + pad * 2, boxY + topPad)
		surface.DrawText(indicator)
	end

	-- Action Points are no longer shown here — they live in the bottom-right
	-- pip-boy bar as "[CB] AP" (see cl_hud_interface.lua). We still set up the
	-- right-column layout vars so the ACTIVE EFFECTS / COOLDOWNS panels below
	-- start at the top of the right column.
	local rightX = ScrW() - 240 * scrModX
	local rightW = 220 * scrModX
	posY = 50 * scrModY
	-- Same extra top padding rule as ACTION / TARGET ACQUIRED so header chips
	-- don't crowd the first body row.
	local topPad = pad * 2

	local buffs = user.getBuffs and user:getBuffs()
	if buffs and table.Count(buffs) > 0 then
		local count = table.Count(buffs)
		local boxH = topPad + pad + lineH * count
		drawTermPanel(rightX, posY, rightW, boxH, "ACTIVE EFFECTS")
		local lineY = posY + topPad
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
		local boxH = topPad + pad + lineH * count
		drawTermPanel(rightX, posY, rightW, boxH, "COOLDOWNS")
		local lineY = posY + topPad
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
		-- Hand the combat-tool's ammo readout to the bottom-right HUD ammo slot
		-- so it isn't shown twice. The HUD picks this up while the entry is
		-- fresh (see cl_hud_interface.lua).
		CYR_CTOOL_AMMO = {clip = ammoAmt, mag = magSize, t = CurTime()}
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

		-- Pass 1: gather one chip per visible limb (screen pos, hit %, box size).
		surface.SetFont("nutCombatHUD")
		local chips = {}
		for _, partName in ipairs(getPartListFor(self.vatsTarget)) do
			local pos = getPartBonePos(self.vatsTarget, partName)
			if pos then
				local sp = pos:ToScreen()
				if sp.visible then
					local isActive = partName == activePart

					-- per-part hit chance (best-effort: needs an action + plugin).
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

					-- Box size matches drawVatsChip's padding (padX 8, padY 2). The
					-- active chip reserves extra height/width for its limb label.
					local tw, th = surface.GetTextSize(chipText)
					local w, h = tw + 16, th + 4
					if isActive then
						local ltw = surface.GetTextSize((PART_LABEL[partName] or partName):upper())
						w = math.max(w, ltw + 14)
						h = h + th + 4
					end
					chips[#chips + 1] = {part = partName, isActive = isActive, text = chipText, x = sp.x, y = sp.y, w = w, h = h}
				end
			end
		end

		-- Pass 2 (NOT in V.A.T.S.): at distance every limb bone projects to nearly
		-- the same pixel, so the chips pile into an unreadable stack. Nudge any
		-- overlapping pair apart along their axis of least penetration, a few
		-- passes, until they're legible. In V.A.T.S. the zoom already spreads them
		-- across the body, so we leave those sitting on their bones.
		if not self.vatsMode and #chips > 1 then
			local GAP = 4
			for _ = 1, 12 do
				local moved = false
				for i = 1, #chips do
					for j = i + 1, #chips do
						local a, b = chips[i], chips[j]
						local dx, dy = b.x - a.x, b.y - a.y
						local penX = (a.w + b.w) * 0.5 + GAP - math.abs(dx)
						local penY = (a.h + b.h) * 0.5 + GAP - math.abs(dy)
						if penX > 0 and penY > 0 then
							moved = true
							if penX < penY then
								local s = (dx ~= 0) and (dx > 0 and 1 or -1) or ((i % 2 == 0) and 1 or -1)
								a.x = a.x - penX * 0.5 * s
								b.x = b.x + penX * 0.5 * s
							else
								local s = (dy ~= 0) and (dy > 0 and 1 or -1) or ((i % 2 == 0) and 1 or -1)
								a.y = a.y - penY * 0.5 * s
								b.y = b.y + penY * 0.5 * s
							end
						end
					end
				end
				if not moved then break end
			end
		end

		-- Pass 3: draw the (possibly nudged) chips; active one is bold + labelled.
		for _, chip in ipairs(chips) do
			local col = chip.isActive and TERM_BRIGHT or TERM_GREEN
			local _, cy = drawVatsChip(chip.x, chip.y, chip.text, col, chip.isActive and 2 or 1)
			if chip.isActive then
				-- inverted label chip above the percentage, FO4 style
				local label = (PART_LABEL[chip.part] or chip.part):upper()
				surface.SetFont("nutCombatHUD")
				local tw, th = surface.GetTextSize(label)
				local lw, lh = tw + 14, th + 2
				local lx = math.Round(chip.x - lw * 0.5)
				local ly = cy - lh - 2
				surface.SetDrawColor(TERM_BRIGHT)
				surface.DrawRect(lx, ly, lw, lh)
				surface.SetTextColor(2, 14, 4, 255)
				surface.SetTextPos(lx + 7, ly + 1)
				surface.DrawText(label)
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

		-- Body uses the smaller HUD font so multi-line TARGET ACQUIRED panels
		-- stay compact; the header (drawn by drawTermPanel) keeps the regular
		-- nutCombatHUD size for readability.
		surface.SetFont("nutCombatHUDSmall")
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

		-- Extra top padding so the header chip (which straddles the top border)
		-- doesn't visually crowd the first body line.
		local topPad = pad * 2
		local boxW = maxW + pad * 4
		local boxH = #lines * targetLineH + topPad + pad
		local boxX = ScrW() * 0.5 - boxW * 0.5
		-- Top-anchor (not centered) so adding lines grows the box downward
		-- instead of upward into the ACTION panel above (which sits at 0.55).
		local boxY = ScrH() * 0.63
		drawTermPanel(boxX, boxY, boxW, boxH, "TARGET ACQUIRED")
		surface.SetFont("nutCombatHUDSmall")
		for i, l in ipairs(lines) do
			surface.SetTextColor(l[2])
			surface.SetTextPos(boxX + pad * 2, boxY + topPad + (i - 1) * targetLineH)
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

	-- Forward declarations for the CalcView / desaturation hook bodies, which
	-- are defined further down in this same CLIENT block.
	local vatsCalcViewFn, vatsDesatFn

	-- Forward decl for the CalcView priority shim. GMod's hook.Call returns
	-- on the FIRST non-nil hook return — and hook.Add always appends — so our
	-- VATS CalcView hook sits at the tail of the event table and gets
	-- preempted by anything earlier that returns a view (the fallout viewbob
	-- plugin is the persistent offender; it returns a view every frame the
	-- player is alive + first-person + has a character). With no priority API
	-- available, we patch competing CalcView hooks in place so they yield
	-- while V.A.T.S. is engaged on this SWEP. SetVATSMode(true) calls this.
	local ensureVATSCamPriority

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
			self.vatsHistory = nil  -- fresh undo history per V.A.T.S. session
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
			-- If the player is aiming at a valid V.A.T.S. target as they enter, LOCK
			-- THAT ENTITY and keep the limb they already had selected (auto-picked
			-- from aim) — entering V.A.T.S. should focus what you're looking at, not
			-- snap to the screen-centre nearest / Body. Only when not aiming at an
			-- eligible target do we fall back to the nearest-to-centre seed.
			local aimedEnt  = self.vatsTarget
			local aimedPart = self.partString
			self.vatsCommittedTarget = nil

			local seed, seedPart
			if IsValid(aimedEnt) then
				for _, t in ipairs(self.vatsTargets or {}) do
					if t == aimedEnt then
						seed, seedPart = aimedEnt, aimedPart
						break
					end
				end
			end
			if not IsValid(seed) then
				local bestDist = math.huge
				local cx, cy = ScrW() * 0.5, ScrH() * 0.5
				for _, t in ipairs(self.vatsTargets or {}) do
					if IsValid(t) then
						local sp = t:WorldSpaceCenter():ToScreen()
						if sp.visible then
							local dx, dy = sp.x - cx, sp.y - cy
							local d = dx * dx + dy * dy
							if d < bestDist then seed, bestDist = t, d end
						end
					end
				end
			end
			self:VATSSetTarget(seed, seedPart)
			-- Kick off the zoom-IN transition. CalcView handles the blend
			-- from the player's normal view → VATS framing, and computes the
			-- duration from camera travel distance (0.2s..0.6s) on its first
			-- frame. We intentionally do NOT pre-seed vatsCamOrigin/Angles/FOV
			-- so the blend starts from the live eye position rather than stale
			-- cached state.
			self.vatsCamPhase         = "in"
			self.vatsCamPhaseStart    = CurTime()
			self.vatsCamTransitionDur = nil
			-- Make sure no other CalcView hook preempts our zoom return.
			-- GMod's hook.Call stops on the FIRST non-nil return — and our
			-- hook always lands at the tail of the event table because
			-- hook.Add appends. Several other CalcView hooks (notably the
			-- fallout viewbob plugin) unconditionally return a view table
			-- whenever you're alive + first-person + holding a weapon, which
			-- means iteration stops before reaching us and the zoom is
			-- invisible. Rather than trying to reorder the global hook list
			-- (no priority API exists), we patch each competing hook to
			-- early-return while V.A.T.S. is engaged on this SWEP. The
			-- wrappers are idempotent (re-wrapping a wrapper is a no-op via
			-- the marker field) and they fall through to the original hook
			-- whenever VATS isn't active, so other addons keep working.
			ensureVATSCamPriority()
			surface.PlaySound("vats wav files/ui_vats_enter.wav")
			surface.PlaySound("vats wav files/ui_vats_camera_in.wav")
		else
			self.vatsTargets = nil
			self.vatsCommittedTarget = nil
			self.vatsMouseAccumX = 0
			self.vatsMouseAccumY = 0
			self.vatsNextFlickT = nil
			-- Drop the Alt cursor if it was up when we exited.
			if self.vatsCursorOn then
				self.vatsCursorOn = false
				gui.EnableScreenClicker(false)
			end
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
		for _, part in ipairs(getPartListFor(target)) do
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

	-- ── Target switching ────────────────────────────────────────────────────
	-- A/D step strictly left/right; W/S step up/down, and only when nothing is
	-- up/down on screen do they fall through to DEPTH (W = next farther target,
	-- S = next nearer). Everything routes through VATSScreenTargets so the
	-- directions mean what you SEE and line up with the numbered labels.

	-- Default aimed part for a freshly-locked target: Torso (this schema calls it
	-- "Body") first, else Head, else a random limb the target actually has, else
	-- nil when it has no limb set at all.
	function SWEP:VATSDefaultPart(target)
		local parts = getPartListFor(target)
		local has = {}
		for _, p in ipairs(parts) do has[p] = true end
		if has["Body"]  then return "Body"  end
		if has["Torso"] then return "Torso" end
		if has["Head"]  then return "Head"  end
		if #parts > 0 then return parts[math.random(#parts)] end
		return nil
	end

	-- Lock a new target and set the aimed part. preferredPart (optional) is kept
	-- when the target actually has that limb — used on V.A.T.S. entry to carry
	-- over the limb the player was already aiming at. Otherwise it falls back to
	-- the target's default (VATSDefaultPart). Centralises target changes so every
	-- path — WASD, number keys, Alt-click, enter/seed — picks a sane limb on the
	-- new body. Returns true if the target changed.
	function SWEP:VATSSetTarget(ent, preferredPart)
		if not IsValid(ent) or ent == self.vatsCommittedTarget then return false end
		-- Record the outgoing target + limb so the spawn-menu undo can step back.
		if IsValid(self.vatsCommittedTarget) then
			self.vatsHistory = self.vatsHistory or {}
			self.vatsHistory[#self.vatsHistory + 1] = {ent = self.vatsCommittedTarget, part = self.partString}
			if #self.vatsHistory > 32 then table.remove(self.vatsHistory, 1) end
		end
		self.vatsCommittedTarget = ent
		local part
		if preferredPart then
			for _, p in ipairs(getPartListFor(ent)) do
				if p == preferredPart then
					part = preferredPart
					break
				end
			end
		end
		part = part or self:VATSDefaultPart(ent)
		if part then self:selectPart(part) end
		return true
	end

	-- Spawn-menu "undo": step back to the previously locked target (and the limb
	-- that was selected on it). Pops the history stack, skipping any entry whose
	-- entity has since died/despawned. Restores state directly so the undo isn't
	-- itself recorded as another step.
	function SWEP:VATSUndoTarget()
		local hist = self.vatsHistory
		while hist and #hist > 0 do
			local snap = hist[#hist]
			hist[#hist] = nil
			if IsValid(snap.ent) then
				self.vatsCommittedTarget = snap.ent
				local part = snap.part
				local ok = false
				for _, p in ipairs(getPartListFor(snap.ent)) do
					if p == part then ok = true break end
				end
				if not ok then part = self:VATSDefaultPart(snap.ent) end
				if part then self:selectPart(part) end
				surface.PlaySound("vats wav files/ui_vats_selecttarget.wav")
				return
			end
		end
	end

	-- Nearest on-screen target in a screen direction (dx,dy unit, y down-positive),
	-- staying on the requested axis so a horizontal step never grabs a mostly-
	-- vertical neighbour and vice-versa. Returns the entity, or nil.
	function SWEP:VATSPickScreen(dx, dy)
		local screen = self:VATSScreenTargets()
		if #screen < 2 then return nil end
		local current = self.vatsCommittedTarget

		-- Anchor at the current target's screen position; if it isn't on screen,
		-- anchor at screen centre so a press still resolves to something.
		local cx, cy
		for _, info in ipairs(screen) do
			if info.ent == current then
				cx, cy = info.x, info.y
				break
			end
		end
		if not cx then cx, cy = ScrW() * 0.5, ScrH() * 0.5 end
		local curPos = IsValid(current) and current:WorldSpaceCenter() or nil

		local horizontal = math.abs(dx) > math.abs(dy)
		local best, bestScore = nil, math.huge
		for _, info in ipairs(screen) do
			if info.ent ~= current then
				local ox, oy = info.x - cx, info.y - cy
				local along  = ox * dx + oy * dy            -- distance in pressed dir
				if along > 8 then
					-- Stay on-axis: A/D ignore mostly-vertical neighbours, W/S
					-- ignore mostly-horizontal ones.
					local onAxis
					if horizontal then onAxis = math.abs(ox) >= math.abs(oy)
					else               onAxis = math.abs(oy) >= math.abs(ox) end
					if onAxis then
						-- Rank survivors by WORLD proximity to the current target,
						-- not screen pixels. A distant enemy sitting near the centre
						-- of the screen has a tiny screen offset and would otherwise
						-- beat the obvious neighbour stood right beside us — that's
						-- why pressing "right" used to jump to a far gecko instead of
						-- the dog running alongside. The screen direction above still
						-- decides WHICH way; world distance decides WHICH one.
						local score
						if curPos then
							score = info.ent:WorldSpaceCenter():DistToSqr(curPos)
						else
							local off = math.abs(ox * -dy + oy * dx)
							score = along + off * 1.5
						end
						if score < bestScore then best, bestScore = info.ent, score end
					end
				end
			end
		end
		return best
	end

	-- Next on-screen target by DEPTH from the player: sign +1 = the next one
	-- farther away, -1 = the next one nearer. The W/S fall-through when there's
	-- nothing directly up/down. Returns the entity, or nil.
	function SWEP:VATSPickDepth(sign)
		local ply = LocalPlayer()
		if not IsValid(ply) then return nil end
		local origin = ply:EyePos()
		local current = self.vatsCommittedTarget
		local curDist = IsValid(current) and current:WorldSpaceCenter():Distance(origin) or 0
		local best, bestDelta = nil, math.huge
		for _, info in ipairs(self:VATSScreenTargets()) do
			if info.ent ~= current then
				local d = info.ent:WorldSpaceCenter():Distance(origin)
				local delta = (d - curDist) * sign  -- >0 means in the requested depth dir
				if delta > 16 and delta < bestDelta then
					best, bestDelta = info.ent, delta
				end
			end
		end
		return best
	end

	-- Dispatch a directional target switch. A/D = pure left/right. W/S = up/down
	-- first, then depth (W farther, S nearer) when nothing is up/down on screen.
	function SWEP:VATSSwitchTarget(dir)
		local t
		if     dir == "left"  then t = self:VATSPickScreen(-1, 0)
		elseif dir == "right" then t = self:VATSPickScreen(1, 0)
		elseif dir == "up"    then t = self:VATSPickScreen(0, -1) or self:VATSPickDepth(1)
		elseif dir == "down"  then t = self:VATSPickScreen(0, 1)  or self:VATSPickDepth(-1)
		end
		if self:VATSSetTarget(t) then
			surface.PlaySound("vats wav files/ui_vats_selecttarget.wav")
		end
	end

	-- Box (hull) trace from the player's eye toward an entity's centre of mass.
	-- The first thing the box hits decides line of sight: if it's the entity
	-- itself (or nothing solid), we can see it; if a wall/prop is hit first, we
	-- can't. A box is more forgiving than a thin line — a sliver of the target
	-- poking past cover still resolves as the first hit, matching what the
	-- player perceives as "visible".
	local VATS_LOS_HULL = Vector(8, 8, 8)
	function SWEP:VATSCanSee(ent)
		local ply = LocalPlayer()
		if not IsValid(ply) or not IsValid(ent) then return false end
		local eye = ply:EyePos()
		-- Only WORLD geometry / solid props should break line of sight. Other
		-- players and combat NPCs are ignored, otherwise a crowd occludes its
		-- own members — a big creature stood in front (or one enemy behind
		-- another) would drop the rear ranks out of the target list even though
		-- they're plainly on screen. In V.A.T.S. you should be able to lock
		-- anything you can see; only a wall between you and it should block.
		local tr = util.TraceHull({
			start = eye,
			endpos = ent:WorldSpaceCenter(),
			mins = -VATS_LOS_HULL,
			maxs = VATS_LOS_HULL,
			filter = function(e)
				if e == ply or e == self then return false end
				if e == ent then return true end                  -- target stops the trace
				if e:IsPlayer() or e.combat then return false end -- see past other combatants
				return true                                        -- world props still block
			end,
			mask = MASK_SHOT,
		})
		return tr.Entity == ent or not tr.Hit
	end

	function SWEP:VATSRefreshTargets()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local origin = ply:GetPos()
		local out = {}
		for _, ent in ipairs(ents.GetAll()) do
			if IsValid(ent) and ent ~= ply
				and (ent.combat or ent:IsPlayer())
				and ent:GetPos():DistToSqr(origin) <= VATS_RANGE_SQR
				and self:VATSCanSee(ent) then
				out[#out + 1] = ent
			end
		end
		-- Nearest first, so the [0]–[9] number labels stay meaningful and stable
		-- between refreshes (closest NPC is always [0]).
		table.sort(out, function(a, b)
			return a:GetPos():DistToSqr(origin) < b:GetPos():DistToSqr(origin)
		end)
		self.vatsTargets = out
	end

	-- The targets currently visible ON SCREEN, in vatsTargets (nearest-first)
	-- order, each with its projected position. This is the canonical list the
	-- number labels, number keys and Alt-cursor click all index into — so an
	-- off-screen target never burns a number and what you click is what you see.
	function SWEP:VATSScreenTargets()
		local out = {}
		for _, t in ipairs(self.vatsTargets or {}) do
			if IsValid(t) then
				local sp = t:WorldSpaceCenter():ToScreen()
				if sp.visible then
					out[#out + 1] = { ent = t, x = sp.x, y = sp.y }
				end
			end
		end
		return out
	end

	-- Lock onto the Nth on-screen target (1-based). Index comes from
	-- VATS_NUM_KEYS, which maps the [0]–[9] labels the overlay paints on screen.
	function SWEP:VATSSelectTargetByIndex(idx)
		local info = self:VATSScreenTargets()[idx]
		if info and self:VATSSetTarget(info.ent) then
			surface.PlaySound("vats wav files/ui_vats_selecttarget.wav")
		end
	end

	-- Alt-cursor click: lock onto the on-screen target nearest the cursor,
	-- provided the click landed reasonably close to one (within VATS_CLICK_RADIUS
	-- pixels) so clicking empty space doesn't snap the selection across the room.
	local VATS_CLICK_RADIUS = 90
	function SWEP:VATSSelectTargetUnderCursor()
		local mx, my = gui.MousePos()
		local best, bestDist = nil, math.huge
		for _, info in ipairs(self:VATSScreenTargets()) do
			local dx, dy = info.x - mx, info.y - my
			local d = dx * dx + dy * dy
			if d < bestDist then best, bestDist = info.ent, d end
		end
		if IsValid(best) and bestDist <= VATS_CLICK_RADIUS * VATS_CLICK_RADIUS then
			if self:VATSSetTarget(best) then
				surface.PlaySound("vats wav files/ui_vats_selecttarget.wav")
			end
		end
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

	-- Number-row key → target list index. [0] selects the first listed target,
	-- [1] the second, … [9] the tenth — matching the overlay's [0]–[9] labels.
	local VATS_NUM_KEYS = {
		[KEY_0] = 1, [KEY_1] = 2, [KEY_2] = 3, [KEY_3] = 4, [KEY_4] = 5,
		[KEY_5] = 6, [KEY_6] = 7, [KEY_7] = 8, [KEY_8] = 9, [KEY_9] = 10,
	}

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

		-- The Pip-Boy owns input while raised: turn V.A.T.S. off when it opens
		-- and don't let Tab toggle it back on underneath. vatsPrevTab is kept in
		-- sync so closing the Pip-Boy doesn't register as a fresh Tab press.
		if PIPBOY_ON_SCREEN then
			if wep.vatsMode then wep:SetVATSMode(false, "cancel") end
			wep.vatsPrevTab = input.IsKeyDown(KEY_TAB)
			return
		end

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

		-- WASD switches the locked TARGET:
		--   A/D → strictly left/right (what you see on screen)
		--   W/S → up/down first; if nothing is up/down, fall through to depth
		--         (W = next farther target, S = next nearer)
		-- Uses pressedRepeating so a held key cycles at VATS_KEY_REPEAT (0.2s),
		-- with the first press firing immediately.
		local dir
		if     pressedRepeating(input.IsKeyDown(KEY_W), wep, "vatsPrevW", "vatsLastW") then dir = "up"
		elseif pressedRepeating(input.IsKeyDown(KEY_S), wep, "vatsPrevS", "vatsLastS") then dir = "down"
		elseif pressedRepeating(input.IsKeyDown(KEY_A), wep, "vatsPrevA", "vatsLastA") then dir = "left"
		elseif pressedRepeating(input.IsKeyDown(KEY_D), wep, "vatsPrevD", "vatsLastD") then dir = "right"
		end
		if dir then
			wep:VATSSwitchTarget(dir)
		end

		-- Number keys [0]–[9] jump straight to a target by its on-screen index.
		-- The overlay labels each NPC with the same number, so [0] picks the
		-- first listed target, [9] the tenth.
		for key, idx in pairs(VATS_NUM_KEYS) do
			if pressedEdge(input.IsKeyDown(key), wep, "vatsPrevNum" .. key) then
				wep:VATSSelectTargetByIndex(idx)
			end
		end

		-- Holding Alt raises a mouse cursor for click-to-select. Toggle the
		-- screen clicker on the edge so we don't spam it every tick, and tear it
		-- down again the moment Alt is released.
		local altDown = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT)
		if altDown ~= (wep.vatsCursorOn or false) then
			wep.vatsCursorOn = altDown
			gui.EnableScreenClicker(altDown)
		end

		if wep.vatsCursorOn then
			-- Cursor mode: LMB locks onto the target under the cursor. Unlike the
			-- no-cursor path this only re-targets (never fires), so it's safe even
			-- if a Derma popup is open — VATSSelectTargetUnderCursor is a no-op
			-- unless the click landed near a target. RMB state is kept synced so
			-- releasing Alt can't manufacture a fake edge that cancels VATS.
			if pressedEdge(input.IsMouseDown(MOUSE_LEFT), wep, "vatsPrevLMB") then
				wep:VATSSelectTargetUnderCursor()
			end
			wep.vatsPrevRMB = input.IsMouseDown(MOUSE_RIGHT)

		-- LMB commits, RMB cancels — but only when no Derma popup has the
		-- cursor. input.IsMouseDown reads raw OS state, so clicking on the
		-- action-list buttons would otherwise be caught here as a VATS
		-- commit/cancel and either fire the attack or exit V.A.T.S. mid-
		-- selection. While the cursor is visible we still resync the
		-- prev-state fields with the current button state so that closing
		-- the popup doesn't manufacture a fake edge on the next tick
		-- (e.g. if the player let go of LMB while the popup was open, we
		-- don't want the very next mouse-up→mouse-down to fire commit).
		elseif vgui.CursorVisible() then
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

		-- Mouse flick: accumulate cmd delta until magnitude crosses threshold,
		-- then resolve to the dominant axis (W/A/S/D) and hop the LIMB picker
		-- that way. After a flick fires we hold a VATS_FLICK_DEBOUNCE cooldown
		-- and zero the accumulator each tick so a continuous mouse sweep can't
		-- rapid-cycle through limbs.
		local mx, my = cmd:GetMouseX(), cmd:GetMouseY()
		if wep.vatsCursorOn then
			-- Alt cursor up: mouse drives the cursor, not the limb picker.
			wep.vatsMouseAccumX = 0
			wep.vatsMouseAccumY = 0
		elseif (wep.vatsNextFlickT or 0) > CurTime() then
			wep.vatsMouseAccumX = 0
			wep.vatsMouseAccumY = 0
		else
			local ax = (wep.vatsMouseAccumX or 0) + mx
			local ay = (wep.vatsMouseAccumY or 0) + my
			local mag = math.sqrt(ax * ax + ay * ay)
			if mag >= VATS_FLICK_THRESHOLD then
				-- Dominant-axis: bigger of |x|,|y| picks horizontal vs vertical.
				local flickDir
				if math.abs(ay) >= math.abs(ax) then
					flickDir = ay < 0 and "w" or "s"
				else
					flickDir = ax < 0 and "a" or "d"
				end
				local nextPart = wep:VATSPickNextPart(flickDir)
				if nextPart and nextPart ~= wep.partString then
					wep:selectPart(nextPart)
					surface.PlaySound("vats wav files/ui_vats_selecttargetpart.wav")
				end
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

	-- Hard-block the spawn menu while V.A.T.S. is engaged. The bind itself is
	-- repurposed as undo in PlayerBindPress above; this also catches any
	-- programmatic / non-bind open so the menu never covers the overlay.
	hook.Add("SpawnMenuOpen", "nut_cswep_vats_block_spawnmenu", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == "nut_cswep" and wep.vatsMode then
			return false
		end
	end)

	-- While V.A.T.S. is engaged, the number-row keys pick targets — so block the
	-- weapon-slot / inv-cycle binds they'd normally trigger, otherwise pressing a
	-- number would also swap weapons (holstering nut_cswep and dropping out of
	-- V.A.T.S.). PlayerBindPress returning true swallows the bind; we only do so
	-- while VATS is active on the combat SWEP, so normal play is unaffected.
	hook.Add("PlayerBindPress", "nut_cswep_vats_blockbinds", function(ply, bind, pressed)
		local wep = ply:GetActiveWeapon()
		if not (IsValid(wep) and wep:GetClass() == "nut_cswep" and wep.vatsMode) then return end
		bind = string.lower(bind)
		-- Spawn menu: don't open it in V.A.T.S. — repurpose the key as an UNDO that
		-- steps back to the previous target. Swallow press AND release so the menu
		-- never appears; only act on the press edge.
		if bind == "+menu" then
			if pressed then wep:VATSUndoTarget() end
			return true
		end
		-- Weapon-slot / inv-cycle binds would swap weapons (dropping out of VATS).
		if bind:find("slot", 1, true) or bind:find("invnext", 1, true) or bind:find("invprev", 1, true) then
			return true
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
	local VATS_CAM_MIN_FRONT = 16  -- keep the cam at least this far in front of the eye so the body stays out of frame
	local VATS_CAM_LIMB_BIAS = 1.0  -- 0 = frame target centre, 1 = frame the limb fully (the per-frame lerp keeps limb changes from snapping)

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

	-- Spherical interpolation of two unit vectors along the shortest great-circle
	-- arc. Falls back to a renormalised straight lerp when they're nearly
	-- parallel/opposite (where the arc is undefined / numerically unstable).
	local function slerpVector(t, a, b)
		local dot = math.Clamp(a:Dot(b), -1, 1)
		local theta = math.acos(dot)
		local sinT = math.sin(theta)
		if sinT < 0.001 then
			local v = LerpVector(t, a, b)
			local len = v:Length()
			return len > 0.001 and (v / len) or a
		end
		return (a * math.sin((1 - t) * theta) + b * math.sin(t * theta)) / sinT
	end

	-- Slerp between two view angles. LerpAngle interpolates pitch/yaw/roll per
	-- component, so when yaw wraps (e.g. 170° → -170°) it winds the long way
	-- round through 0° and the camera can spin or flip upside down. Instead we
	-- slerp the FORWARD direction along the shortest arc and carry roll across
	-- with a shortest-path lerp, so the blend always takes the natural path.
	local function slerpAngle(frac, a, b)
		local out = slerpVector(frac, a:Forward(), b:Forward()):Angle()
		out.r = a.r + math.NormalizeAngle(b.r - a.r) * frac
		return out
	end

	-- vatsCamPhase semantics:
	--   "in"   → blending FROM player's eye view TO VATS framing  (0.2s)
	--   nil + vatsMode=true  → active VATS, per-frame inter-limb lerp
	--   "out"  → blending FROM cached VATS view BACK to player's eye view (0.2s)
	-- vatsCamPhaseStart is the CurTime() at which the current transition began.
	vatsCalcViewFn = function(ply, origin, angles, fov)
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
			-- Focus fully on the ACTIVE LIMB (VATS_CAM_LIMB_BIAS = 1). The per-frame
			-- lerp below smooths the pan so changing limbs glides rather than snaps.
			local center = target:WorldSpaceCenter()
			local limbPos = getPartBonePos(target, wep.partString or "Body") or center
			local lookPos = LerpVector(VATS_CAM_LIMB_BIAS, center, limbPos)
			local toTarget = lookPos - origin
			local dist = toTarget:Length()
			if dist >= 1 then
				local dir = toTarget / dist
				-- Tighter framing than full-body: pull back only gently with target
				-- size so a big creature's limb still has a little room, but the
				-- shot stays zoomed IN on the limb (zoom out less). Clamped to keep
				-- the cam at least VATS_CAM_MIN_FRONT in front of the eye so the
				-- player's body never drops into shot.
				local size = target:OBBMaxs():Distance(target:OBBMins())
				local want = math.Clamp(size * 1.2, VATS_CAM_DIST, VATS_CAM_DIST * 1.8)
				local camDist = math.min(want, math.max(dist - VATS_CAM_MIN_FRONT, 0))
				desiredOrigin = lookPos - dir * camDist
				desiredAngles = dir:Angle()
				desiredFOV    = VATS_CAM_FOV
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
			local a = slerpAngle(frac, angles, desiredAngles)
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
				angles     = slerpAngle(frac, fromA, angles),
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
		wep.vatsCamAngles = slerpAngle(frac, wep.vatsCamAngles, desiredAngles)
		wep.vatsCamFOV    = Lerp     (frac, wep.vatsCamFOV,    desiredFOV)

		return {
			origin     = wep.vatsCamOrigin,
			angles     = wep.vatsCamAngles,
			fov        = wep.vatsCamFOV,
			drawviewer = true,  -- show the player's body since the cam is offset
		}
	end
	hook.Add("CalcView", "nut_cswep_vats_view", vatsCalcViewFn)

	-- ──────────────────────────────────────────────────────────────────────
	-- CalcView priority shim. See the forward-decl comment above for why.
	--
	-- Walks the current CalcView hook table and, for every entry except our
	-- own, re-adds it as a wrapper that early-returns nil while VATS is
	-- engaged on this SWEP. Returning nil from a hook lets hook.Call keep
	-- iterating, so our zoom hook (still at the tail) finally gets reached.
	-- When VATS isn't active the wrapper just tail-calls the original and
	-- behaviour is unchanged.
	--
	-- The wrapper is marked with `_nut_vats_wrapped = true` so re-running
	-- ensureVATSCamPriority is a no-op for hooks we already patched. New
	-- CalcView hooks registered between engages get caught next time.
	--
	-- We deliberately do NOT touch our own hook name here — that's what the
	-- vatsCalcViewFn upvalue is for, and re-adding it with hook.Add would
	-- just replace it in place without changing iteration position.
	-- Set of functions we've already wrapped, so re-running the helper on
	-- subsequent VATS engages doesn't double-wrap or wrap our own wrappers.
	-- Has to be a side table because Lua functions aren't indexable.
	local vatsWrappedFns = setmetatable({}, { __mode = "k" })  -- weak keys

	ensureVATSCamPriority = function()
		local tbl = hook.GetTable().CalcView
		if not tbl then return end
		for name, fn in pairs(tbl) do
			if name ~= "nut_cswep_vats_view" and type(fn) == "function" and not vatsWrappedFns[fn] then
				local original = fn
				local wrapper
				wrapper = function(...)
					-- Use LocalPlayer() instead of inspecting the first arg.
					-- For hooks added with a table identifier (nutscript
					-- PLUGIN:CalcView style), hook.Call invokes them as
					-- func(object, ply, ...) so the first vararg is the
					-- PLUGIN table, NOT the player. Reading LocalPlayer()
					-- side-steps that ambiguity entirely — we don't care how
					-- the hook is dispatched, just whether the local player
					-- is currently in VATS on the combat SWEP.
					local lp = LocalPlayer()
					if IsValid(lp) then
						local w = lp:GetActiveWeapon()
						if IsValid(w) and w:GetClass() == "nut_cswep" and (w.vatsMode or w.vatsCamPhase == "out") then
							return  -- yield to nut_cswep_vats_view
						end
					end
					return original(...)
				end
				vatsWrappedFns[wrapper] = true
				-- hook.Add updates in place when `name` already exists, so
				-- this swaps the stored function without changing slot.
				hook.Add("CalcView", name, wrapper)
			end
		end
	end

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
	vatsDesatFn = function(bDepth, bSkybox, bDraw3DSkybox)
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
	end
	hook.Add("PostDrawTranslucentRenderables", "nut_cswep_vats_desat", vatsDesatFn)
end
