local PLUGIN = PLUGIN

--This is where I'd put item related actions and stuff like that probably.
--[[
local ACT = {}
ACT.uid = "bomb_1"
ACT.name = "Bomb (Weak)"
ACT.desc = "An object that explodes."
ACT.attackString = "detonates a weak bomb, damaging"
ACT.category = "Other"
ACT.dmgT = "Fire"
ACT.dmg = 30
ACT.costMP = 0
ACT.radius = 200
ACT.restrict = true
ACTS:Register(ACT)
--]]
--
local ACT = {}
ACT.uid = "throwing_spear"
ACT.name = "Throwing Spear"
ACT.desc = "A long throwing spear either hand-crafted, or improvised, with a bladed end."
ACT.attackString = "throws a spear at"
ACT.category = "Other"
ACT.dmgT = "Pierce"
ACT.dmg = 60
ACT.costMP = 0
ACT.itemCons = true --for consumable items
ACT.notarget = false
ACT.restrict = true
ACT.noAmmo = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "throwing_protonaxe"
ACT.name = "Throwing Proton Axe"
ACT.desc = "A prototype energy-based throwing axe."
ACT.attackString = "throws a Proton Axe at"
ACT.category = "Other"
ACT.dmgT = "Laser"
ACT.dmg = 90
ACT.costMP = 0
ACT.itemCons = true --for consumable items
ACT.notarget = false
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "throwing_knife"
ACT.name = "Throwing Knife"
ACT.desc = "A weighted, thin blade with no handle, meant for throwing."
ACT.attackString = "throws a knife at"
ACT.category = "Other"
ACT.dmgT = "Pierce"
ACT.dmg = 45
ACT.costMP = 0
ACT.itemCons = true --for consumable items
ACT.notarget = false
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "throwing_hatchet"
ACT.name = "Throwing Hatchet"
ACT.desc = "A short hatchet weighted and balanced to be thrown."
ACT.attackString = "throws a hatchet at"
ACT.category = "Other"
ACT.dmgT = "Pierce"
ACT.dmg = 55
ACT.costMP = 0
ACT.itemCons = true --for consumable items
ACT.notarget = false
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_frag"
ACT.name = "Fragmentation Grenade"
ACT.desc = "A grenade that sends many bits of shrapnel out in its blast radius."
ACT.attackString = "tosses a frag grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Explosion"
ACT.dmg = 65
ACT.costMP = 0
ACT.radius = 200
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "mine_frag"
ACT.name = "Fragmentation Mine"
ACT.desc = "A mine that sends many bits of shrapnel out in its blast radius."
ACT.attackString = "detonates a frag mine, damaging"
ACT.category = "Other"
ACT.dmgT = "Explosion"
ACT.dmg = 70
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "mine_plasma"
ACT.name = "Plasma Mine"
ACT.desc = "A magnetically sealed plasma unit with detonating explosives."
ACT.attackString = "detonates a plasma mine, damaging"
ACT.category = "Other"
ACT.dmgT = "Plasma"
ACT.dmg = 90
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_plasma"
ACT.name = "Plasma Grenade"
ACT.desc = "A magnetically sealed plasma unit with detonating explosives."
ACT.attackString = "tosses a plasma grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Plasma"
ACT.dmg = 90
ACT.costMP = 0
ACT.radius = 200
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_dynamite"
ACT.name = "Dynamite"
ACT.desc = "An explosive stick of nitroglycerin soaked powder wrapped in wax paper."
ACT.attackString = "tosses a stick of dynamite, damaging"
ACT.category = "Other"
ACT.dmgT = "Explosion"
ACT.dmg = 55
ACT.costMP = 0
ACT.radius = 200
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_tincan"
ACT.name = "Tin Can Grenade"
ACT.desc = "An improvised hand-thrown explosive assembled with scrap in a tin-can grenade."
ACT.attackString = "tosses a tin can grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Explosion"
ACT.dmg = 45
ACT.costMP = 0
ACT.radius = 200
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "mine_bottlecap"
ACT.name = "Bottlecap Mine"
ACT.desc = "A homemade proximity mine using an old lunchbox, a lot of gunpowder, and bottlecaps for shrapnel."
ACT.attackString = "detonates a bottlecap mine, damaging"
ACT.category = "Other"
ACT.dmgT = "Explosion"
ACT.dmg = 80
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "mine_pulse"
ACT.name = "Pulse Mine"
ACT.desc = "An energy-based pulse mine that releases a magnetic pulse when triggered."
ACT.attackString = "detonates a pulse mine, damaging"
ACT.category = "Other"
ACT.dmgT = "Laser"
ACT.dmg = 50
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "grenade_pulse"
ACT.name = "Pulse Grenade"
ACT.desc = "An energy-based grenade that releases a magnetic pulse when triggered."
ACT.attackString = "tosses a pulse grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Laser"
ACT.dmg = 50
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "grenade_mfccluster"
ACT.name = "MFC Cluster Grenade"
ACT.desc = "An improvised grenade utilizing multiple multifusion cells set around a charge."
ACT.attackString = "tosses a MFC Cluster grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Laser"
ACT.dmg = 45
ACT.multi = 3
ACT.costMP = 0
ACT.radius = 250
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_mfcgrenade"
ACT.name = "MFC Grenade"
ACT.desc = "An improvised grenade utilizing multiple multifusion cells set around a charge."
ACT.attackString = "tosses a MFC grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Laser"
ACT.dmg = 65
ACT.costMP = 0
ACT.radius = 200
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_firebomb"
ACT.name = "Molotov Cocktail"
ACT.desc = "A Sunset Sarsparilla bottle filled with flammable liquids with a rag tucked in it."
ACT.attackString = "tosses an molotov, igniting"
ACT.category = "Other"
ACT.dmgT = "Fire"
ACT.dmg = 25
ACT.costMP = 0
ACT.radius = 200
ACT.restrict = true
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "Burning",
		effect = "DOT",
		duration = 3,
		dmg = 10,
		dmgT = "Fire",
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "grenade_plasma"
ACT.name = "Plasma Grenade"
ACT.desc = "A grenade that explodes and blasts its radius with plasma."
ACT.attackString = "tosses a plasma grenade, damaging"
ACT.category = "Other"
ACT.dmgT = "Plasma"
ACT.dmg = 75
ACT.costMP = 0
ACT.radius = 150
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "grenade_flash"
ACT.name = "Flash Grenade"
ACT.desc = "A grenade that blinds those in its radius."
ACT.attackString = "tosses a flash grenade, blinding"
ACT.category = "Other"
ACT.costMP = 0
ACT.radius = 350
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "Flashed",
		effect = "blind",
		duration = 2,
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_stun"
ACT.name = "Stun Grenade"
ACT.desc = "A grenade that stuns those in its radius."
ACT.attackString = "tosses a stun grenade, stunning"
ACT.category = "Other"
ACT.costMP = 0
ACT.radius = 300
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "Disoriented",
		effect = "blind",
		duration = 2,
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_emp"
ACT.name = "EMP Grenade"
ACT.desc = "A grenade that disables electronics in its radius."
ACT.attackString = "tosses an EMP grenade, disabling the electronics of"
ACT.category = "Other"
ACT.costMP = 0
ACT.radius = 300
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "EMP",
		effect = "hack",
		duration = 2,
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grenade_foam"
ACT.name = "Foam Grenade"
ACT.desc = "A grenade that deploys an immense amount of foam, restricting the movements of those in its radius."
ACT.attackString = "tosses a foam grenade, disabling the movements of"
ACT.category = "Other"
ACT.costMP = 0
ACT.radius = 400
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "Foam",
		effect = "root",
		duration = 2,
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_pistol_ap"
ACT.name = "AP Pistol"
ACT.desc = "An armor penetrating pistol shot."
ACT.attackString = "fires at"
ACT.category = "Other"
ACT.costMP = 0
ACT.weaponMult = 1
ACT.dmg = 0
ACT.dmgT = "AP (Pistol)"
ACT.itemCons = true --for consumable items
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_smg_ap"
ACT.name = "AP SMG"
ACT.desc = "An armor penetrating SMG shot."
ACT.attackString = "fires at"
ACT.category = "Other"
ACT.costMP = 0
ACT.weaponMult = 1
ACT.dmg = 0
ACT.dmgT = "AP (SMG)"
ACT.itemCons = true --for consumable items
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_rifle_ap"
ACT.name = "AP Rifle"
ACT.desc = "An armor penetrating rifle shot."
ACT.attackString = "fires at"
ACT.category = "Other"
ACT.costMP = 0
ACT.weaponMult = 1
ACT.dmg = 0
ACT.dmgT = "AP (Rifle)"
ACT.itemCons = true --for consumable items
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_sniper_ap"
ACT.name = "AP Sniper"
ACT.desc = "An armor penetrating sniper shot."
ACT.attackString = "fires at"
ACT.category = "Other"
ACT.costMP = 0
ACT.weaponMult = 1
ACT.dmg = 0
ACT.dmgT = "AP (Sniper)"
ACT.itemCons = true --for consumable items
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_slug"
ACT.name = "Shotgun Slug"
ACT.desc = "A shotgun slug."
ACT.attackString = "fires a shotgun slug at"
ACT.category = "Other"
ACT.costMP = 0
ACT.weaponMult = 2
ACT.dmg = 0
ACT.dmgT = "Blunt"
ACT.itemCons = true --for consumable items
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_explosive"
ACT.name = "HE Shell"
ACT.desc = "A high explosive shell."
ACT.attackString = "fires an HE Slug at"
ACT.category = "Other"
ACT.costMP = 0
ACT.dmg = 60
ACT.dmgT = "Explosion"
ACT.radius = 100
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "ammo_fire"
ACT.name = "Dragon's Breath"
ACT.desc = "An incendiary shell."
ACT.attackString = "fires an incendiary shell at"
ACT.category = "Other"
ACT.costMP = 0
ACT.dmg = 60
ACT.dmgT = "Fire"
ACT.radius = 60
ACT.itemCons = true --for consumable items
ACT.notarget = true
ACT.restrict = true
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "drone_heal"
ACT.name = "Heal (Drone)"
ACT.desc = "Heal the target for "
ACT.attackString = "performs first aid on"
ACT.category = "Drone"
ACT.costAP = 1
--ACT.itemCons = true --for consumable items
--ACT.notarget = true
ACT.restrict = true
ACT.special = function(client, target)
	target:addHP(35)
end
ACTS:Register(ACT)