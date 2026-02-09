local PLUGIN = PLUGIN

--ACTIVE PERKS
//
local TRAIT = {}
TRAIT.uid = "animal" 
TRAIT.name = "Animal Friend"
TRAIT.desc = "Allowed to roll speech checks against hostile animals to pacify them."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Animal Friend.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "double" 
TRAIT.name = "Double Check"
TRAIT.desc = "May reroll Luck checks once per encounter."
TRAIT.category = "Perk (Active)"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "light" 
TRAIT.name = "Light Step"
TRAIT.desc = "May reroll checks against traps once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Light Step.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "ninja" 
TRAIT.name = "Ninja"
TRAIT.desc = "May reroll Stealth checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Ninja.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "nimble" 
TRAIT.name = "Nimble Footed"
TRAIT.desc = "May reroll Athletics checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Nimble Footed.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "peer" 
TRAIT.name = "Peer Review"
TRAIT.desc = "May reroll Science checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Peer Review.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "talk" 
TRAIT.name = "Smooth Talker"
TRAIT.desc = "May reroll Speech checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Smooth Talker.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "doctor" 
TRAIT.name = "Miracle Doctor"
TRAIT.desc = "May reroll Medicine checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Miracle Doctor.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "jury" 
TRAIT.name = "Jury Rigging"
TRAIT.desc = "May reroll Repair checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/unsorted/Jury Rigging.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "thief" 
TRAIT.name = "Master Thief"
TRAIT.desc = "May reroll Lockpicking checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Master Thief.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "driver" 
TRAIT.name = "Sunday Driver"
TRAIT.desc = "May reroll Piloting checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/Sunday Driver.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "survive" 
TRAIT.name = "Survivalist"
TRAIT.desc = "May reroll Survival checks once."
TRAIT.category = "Perk (Active)"
TRAIT.icon = "fonvui/hud/icons/perks/skills/skills_survival.png"
TRAITS:Register(TRAIT)

--PASSIVE PERKS
//
local TRAIT = {}
TRAIT.uid = "evader" 
TRAIT.name = "Evader"
TRAIT.desc = "Your Evasion is counted as being 10 points higher."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Evader.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "skull" 
TRAIT.name = "Adamantium Skull"
TRAIT.desc = "-30% damage from headshots."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Adamantium Skull.png"
TRAIT.OnDamageProcess = function(self, attackData, dmgTbl)
	if(dmgTbl.part and dmgTbl.part == "Head") then
		for k, v in pairs(dmgTbl.damage or {}) do
			v.dmg = v.dmg * 0.7
		end
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "thickskin" 
TRAIT.name = "Thick Skin"
TRAIT.desc = "Receive -20% damage from ballistic weapons and melee."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Thick Skin.png"
TRAIT.OnDamageProcess = function(self, attackData, dmgTbl)
	for k, v in pairs(dmgTbl.damage or {}) do
		local dmgT = v.dmgT
	
		if(nut.plugin.list["combat"]:IsBroadType(dmgT, "kinetic")) then
			v.dmg = v.dmg * 0.8
		end
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "mess" 
TRAIT.name = "Bloody Mess"
TRAIT.desc = "+8% damage with all weapon types."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Bloody Mess.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	if(action.dmg) then
		action.dmg = action.dmg * 1.08
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "bettercrits" 
TRAIT.name = "Better Crits"
TRAIT.desc = "+25% Critical Damage"
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Better Crits.png"
TRAITS:Register(TRAIT)
//
--[[
local TRAIT = {}
TRAIT.uid = "center" 
TRAIT.name = "Center of Mass"
TRAIT.desc = "Deal +25% more damage to arms and legs."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Center Of Mass.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local partString = info.partString

	local parts = {
		"Left Arm",
		"Right Arm",
		"Left Leg",
		"Right Leg",
	}

	if(partString and (parts[partString])) then
		action.dmg = action.dmg * 1.25
	end
end
TRAITS:Register(TRAIT)
--]]
//
local TRAIT = {}
TRAIT.uid = "center" 
TRAIT.name = "Center of Mass"
TRAIT.desc = "+35% accuracy when targetting the torso."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Center Of Mass.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local partString = info.partString

	if(partString and partString == "Body" and action.accuracy) then
		action.accuracy = action.accuracy + math.abs(action.accuracy * 0.35)
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "heave" 
TRAIT.name = "Heave Ho!"
TRAIT.desc = "May utilize throwing weapons up to 4x movement range."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Heave Ho.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "fist" 
TRAIT.name = "Iron Fist"
TRAIT.desc = "+15% unarmed (weapon) damage."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Iron Fist.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	if(action.uid and action.uid == "punch") then
		action.dmg = action.dmg*1.15
	end

	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Unarmed") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "gunslinger" 
TRAIT.name = "Gunslinger"
TRAIT.desc = "+15% damage with pistols/revolvers using the Guns skill."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Gunslinger.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Pistol") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "rifleman" 
TRAIT.name = "Rifleman"
TRAIT.desc = "+15% damage with Precision Rifles and Assault Rifles using the Guns skill."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Rifleman.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Rifle") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
--[[
local TRAIT = {}
TRAIT.uid = "sniper" 
TRAIT.name = "Sniper"
TRAIT.desc = "+10% damage with sniper/precision rifles."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Sniper.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Sniper") then
		action.dmg = action.dmg*1.1
	end
end
TRAITS:Register(TRAIT)
--]]
//
local TRAIT = {}
TRAIT.uid = "pointman" 
TRAIT.name = "Pointman"
TRAIT.desc = "+15% damage with SMGs/Shotguns."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Pointman.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "SMG" or weaponItem.weaponType == "Shotgun") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "heavygunner" 
TRAIT.name = "Heavy Gunner"
TRAIT.desc = "+15% damage with LMGs."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Heavy Gunner.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "LMG") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "lasercommando" 
TRAIT.name = "Laser Commando"
TRAIT.desc = "+15% damage with energy weapons."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Laser Commando.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Energy") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "barbarian" 
TRAIT.name = "Barbarian"
TRAIT.desc = "+15% damage with melee weapons."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Barbarian.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	local weapon = info.weapon
	if(!weapon) then return end
	
	local weaponItem = nut.item.instances[weapon]
	if(!weaponItem) then return end

	if(weaponItem.weaponType == "Melee") then
		action.dmg = action.dmg*1.15
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "lifegiver" 
TRAIT.name = "Lifegiver"
TRAIT.desc = "+25 Max HP."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Life Giver.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "quickdraw" 
TRAIT.name = "Quickdraw"
TRAIT.desc = "May draw and swap weapons without utilizing AP."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Quickdraw.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "refractor" 
TRAIT.name = "Refractor"
TRAIT.desc = "Receive -20% damage from energy weapons."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Refractor.png"
TRAIT.OnDamageProcess = function(self, attackData, dmgTbl)
	for k, v in pairs(dmgTbl.damage or {}) do
		local dmgT = v.dmgT
		
		if(nut.plugin.list["combat"]:IsBroadType(dmgT, "energy")) then
			v.dmg = v.dmg * 0.8
		end
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "sniper" 
TRAIT.name = "Sniper"
TRAIT.desc = "+20% accuracy to headshots."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/sniper.png"
TRAIT.OnAttackData = function(self, action, attacker, info)
	if(info.partString and info.partString == "Head") then
		action.accuracy = action.accuracy + math.abs(action.accuracy * 0.2)
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "toughness" 
TRAIT.name = "Toughness"
TRAIT.desc = "+10% Damage Resistance."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Toughness.png"
TRAIT.OnDamageProcess = function(self, attackData, dmgTbl)
	for k, v in pairs(dmgTbl.damage or {}) do
		v.dmg = v.dmg * 0.9
	end
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "healer" 
TRAIT.name = "Healer"
TRAIT.desc = "Heal 25% more when healing other players."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Healer.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "moving_target" 
TRAIT.name = "Moving Target"
TRAIT.desc = "May move 2 AP distance for the cost of 1."
TRAIT.category = "Perks (Passive)"
TRAIT.icon = "fonvui/hud/icons/perks/Moving Target.png"
TRAITS:Register(TRAIT)

--PROFESSIONS

//
local TRAIT = {}
TRAIT.uid = "gunsmith" 
TRAIT.name = "Gunsmith"
TRAIT.desc = "Can repair, modify, or design firearms."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Weapon Master.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "armorsmith" 
TRAIT.name = "Armorsmith"
TRAIT.desc = "Can repair, modify, or design armor."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Weapon Master.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "science" 
TRAIT.name = "Science!"
TRAIT.desc = "Can utilize Energy Weapons, Robotics, and Chem Workbenches."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Science!.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "chef" 
TRAIT.name = "Wasteland Chef"
TRAIT.desc = "Can utilize cooking workbench."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Wasteland Chef.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "ammosmith" 
TRAIT.name = "Ammo Smith"
TRAIT.desc = "Can create ammo using the Ammo Bench."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Weapon Master.png"
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "augdoc" 
TRAIT.name = "Augment Doctor"
TRAIT.desc = " "
TRAIT.category = "Professions"
TRAIT.hidden = true
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "blacksmith" 
TRAIT.name = "Blacksmith"
TRAIT.desc = "Can repair, modify, or design melee weapons."
TRAIT.category = "Professions"
TRAIT.icon = "fonvui/hud/icons/perks/Weapon Master.png"
TRAITS:Register(TRAIT)
//
--faction innates
//
local TRAIT = {}
TRAIT.uid = "robotic" 
TRAIT.name = "Robotic Body"
TRAIT.desc = "+30% Kinetic Resistance, -30% Energy Resistance."
TRAIT.hidden = true
TRAIT.category = "Perks (Race)"
--TRAIT.icon = "fonvui/hud/icons/perks/Toughness.png"
TRAIT.onLoaded = function(client)
	local buff = {
		uid = TRAIT.uid,
		name = TRAIT.name,
		
		res = {
			["Kinetic"] = 30,
			["Energy"] = -30,
		},
		
		hidden = true
	}
	
	client:addBuff(buff)
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "ghoul" 
TRAIT.name = "Ghoul Body"
TRAIT.desc = "+70% Radiation Resistance."
TRAIT.category = "Perks (Race)"
TRAIT.hidden = true
--TRAIT.icon = "fonvui/hud/icons/perks/Toughness.png"
TRAIT.onLoaded = function(client)
	local buff = {
		uid = TRAIT.uid,
		name = TRAIT.name,
		
		res = {
			["Radiation"] = 70,
		},
		
		hidden = true
	}
	
	client:addBuff(buff)
end
TRAITS:Register(TRAIT)
//
local TRAIT = {}
TRAIT.uid = "supermutant" 
TRAIT.name = "Supermutant Body"
TRAIT.desc = "+75% Radiation Resistance, 25% Kinetic Resistance, -15 Evasion, +100 Health"
TRAIT.category = "Perks (Race)"
TRAIT.hidden = true
--TRAIT.icon = "fonvui/hud/icons/perks/Toughness.png"
TRAIT.onLoaded = function(client)
	local buff = {
		uid = TRAIT.uid,
		name = TRAIT.name,

		res = {
			["Radiation"] = 75,
			["Kinetic"] = 25,
		},
		
		evasion = -15,
		hpMax = 100,
		
		hidden = true
	}
	
	client:addBuff(buff)
end
TRAITS:Register(TRAIT)
//

