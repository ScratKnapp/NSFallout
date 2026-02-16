local PLUGIN = PLUGIN

local ACT = {}
ACT.uid = "burnap"
ACT.name = "Burn 1 AP"
ACT.desc = "To help keep track of movement and interacting with objects."
ACT.attackString = "uses 1 AP"
ACT.category = "Default"
ACT.costAP = 1
ACT.CD = 0
ACT.selfOnly = true
ACT.notarget = true
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "burnap2"
ACT.name = "Burn 2 AP"
ACT.desc = "To help keep track of movement and interacting with objects."
ACT.attackString = "uses 2 AP"
ACT.category = "Default"
ACT.costAP = 2
ACT.CD = 0
ACT.selfOnly = true
ACT.notarget = true
ACTS:Register(ACT)

--

local ACT = {}
ACT.uid = "punch"
ACT.name = "Punch"
ACT.desc = "Punch, with your fists."
ACT.attackString = "punches"
ACT.category = "Default"
ACT.costAP = 1
ACT.dmg = 5
ACT.mult = {
	["str"] = 2,
}
ACTS:Register(ACT)

local ACT = {}
ACT.uid = "watergun"
ACT.name = "Water Gun"
ACT.desc = "Gecko spits straight FIRE."
ACT.attackString = "spits globs of Plasma at"
ACT.category = "Nibbles"
ACT.costAP = 1
ACT.dmg = 50
ACT.dmgT = "Plasma"
ACT.accuracy = 25
ACT.multi = 3
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "combo"
ACT.name = "Combination"
ACT.desc = "Attack with a practiced technique with multiple strikes."
ACT.attackString = "strikes multiple times at"
ACT.category = "Melee"
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.multi = 3
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "dodge"
ACT.name = "Dodge"
ACT.desc = "Gives you increased evasion for the next two hits, last one turn."
ACT.attackString = "prepares to dodge"
ACT.category = "Default"
ACT.costAP = 1
ACT.CD = 1
ACT.selfOnly = true
ACT.notarget = true
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Dodging",
        effect = "dodging",
        duration = 1,
        strength = 1,

		evasion = 200,

		hitsDef = 1,
		
		selfApply = true,
		buff = true,
    }
}
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "reload"
ACT.name = "Reload"
ACT.desc = "Reloads all of your weapons."
--ACT.attackString = "fires a rapid burst at"
ACT.category = "Default"
ACT.costAP = 1
ACT.attackOverwrite = function(actionTbl, client, trace)
	if(client:IsPlayer()) then
		local char = client:getChar()
		local inventory = char:getInv()
		
		local equipment = nut.plugin.list["equipment"]:getEquippedItems(client, true)

		local weaponsReloaded = {}
		for k, v in pairs(equipment) do
			if(v.magSize) then
				if(nut.plugin.list["fancyammo"]:ReloadFromInventory(client, v)) then
					weaponsReloaded[#weaponsReloaded+1] = v
				end
			end
		end

		for k, v in pairs(weaponsReloaded) do
			local combatMsg = client:Name().. " reloads " ..v:getName().. "."
		
			nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", combatMsg)
			nut.log.addRaw(combatMsg, 2)
		end
	else
		local combatMsg = client:Name().. " reloads their weapon(s)."
		
		nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", combatMsg)
		nut.log.addRaw(combatMsg, 2)
	end
end
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "grapple"
ACT.name = "Grapple"
ACT.desc = "Attempt to grapple the target you are looking at. Uses your strength and aim against their strength and reflexes."
--ACT.attackString = "fires a rapid burst at"
ACT.category = "Default"
ACT.costAP = 1
ACT.attackOverwrite = function(actionTbl, client, trace)
	local target = trace.Entity
	if(IsValid(target) and (target:IsPlayer() or target.combat)) then
		local str
		local aim
		if(client:IsPlayer()) then
			local char = client:getChar()
			
			str = char:getAttrib("strength", 0)
			aim = char:getAttrib("perception", 0)
		else
			str = client.attribs["strength"] or 0
			aim = client.attribs["perception"] or 0
		end
		
		local reflexesT
		if(target:IsPlayer()) then
			local targetChar = target:getChar()
			reflexesT = targetChar:getAttrib("agility", 0)
		else
			reflexesT = target.attribs["agility"] or 0
		end
		
		local attackRoll = math.Rand(1, 20) + str + aim
		local defenseRoll = math.Rand(1, 20) + reflexesT
	
		local result = "FAIL"
		if(attackRoll > defenseRoll) then
			result = "SUCCESS"
		end
	
		local combatMsg = client:Name().. " attempts to grapple " ..target:Name() .. " [" ..result.. "]."
		
		--nut.chat.send(client, "react_npc", combatMsg) --print it
		nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", combatMsg)
		nut.log.addRaw(combatMsg, 2)
	else
		if(client:IsPlayer()) then
			client:notify("Aim at a valid target.")
		end
	end
end
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "grapple2"
ACT.name = "Grapple Escape"
ACT.desc = "Attempt to escape a grapple. Target the person grappling you."
--ACT.attackString = "fires a rapid burst at"
ACT.category = "Default"
ACT.costAP = 1
ACT.attackOverwrite = function(actionTbl, client, trace)
	local target = trace.Entity
	if(IsValid(target) and (target:IsPlayer() or target.combat)) then
		local str
		local reflexes
		if(client:IsPlayer()) then
			local char = client:getChar()
			
			str = char:getAttrib("strength", 0)
			reflexes = char:getAttrib("agility", 0)
		else
			str = client.attribs["strength"] or 0
			reflexes = client.attribs["agility"] or 0
		end
		
		local strT
		if(target:IsPlayer()) then
			local targetChar = target:getChar()
			strT = targetChar:getAttrib("agility", 0)
		else
			strT = target.attribs["agility"] or 0
		end
		
		local attackRoll = math.Rand(1, 20) + str + reflexes
		local defenseRoll = math.Rand(1, 20) + strT
	
		local result = "FAIL"
		if(attackRoll > defenseRoll) then
			result = "SUCCESS"
		end
	
		local combatMsg = client:Name().. " attempts to escape " ..target:Name() .. "'s grapple [" ..result.. "]."
		
		--nut.chat.send(client, "react_npc", combatMsg) --print it
		nut.plugin.list["chatboxextra"]:ChatboxSend(client, "react_npc", combatMsg)
		nut.log.addRaw(combatMsg, 2)
	else
		if(client:IsPlayer()) then
			client:notify("Aim at a valid target.")
		end
	end
end
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "burstfire_smg"
ACT.name = "Rapid Fire (SMG)"
ACT.desc = "Fire five bullets at a target with reduced accuracy."
ACT.attackString = "fires a rapid burst at"
ACT.category = "Gun"
ACT.CD = 1
ACT.costAP = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -10
ACT.accuracyMult = 1
ACT.multi = 5
ACT.ammoUse = 5 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "doubletap_pistol"
ACT.name = "Double Tap (Pistol)"
ACT.desc = "Fire two rounds with no accuracy penalty."
ACT.attackString = "fires two rounds at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -2
ACT.accuracyMult = 1
ACT.multi = 2
ACT.ammoUse = 2 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "doubletap_precision"
ACT.name = "Double Tap (Precision Rifle)"
ACT.desc = "Fire two rounds with no accuracy penalty."
ACT.attackString = "fires two rounds at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -2
ACT.accuracyMult = 1
ACT.multi = 2
ACT.critC = -9
ACT.ammoUse = 2 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "burstfire_rifle"
ACT.name = "Burst Fire (Rifle)"
ACT.desc = "Fire three bullets at a target with reduced accuracy."
ACT.attackString = "fires a burst at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 3
ACT.critC = -9
ACT.ammoUse = 3 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "burstfire_lmg"
ACT.name = "Burst Fire (LMG)"
ACT.desc = "Fire five bullets at a target with reduced accuracy."
ACT.attackString = "fires a burst at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -5
ACT.accuracyMult = 1
ACT.multi = 5
ACT.critC = -10
ACT.ammoUse = 5 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "runngun"
ACT.name = "Run and Gun"
ACT.desc = "Move 1 AP distance and attack an enemy for only one AP cost."
ACT.category = "Gun"
ACT.restrict = true
ACT.attackString = "fires while moving at"
ACT.costAP = 1
ACT.CD = 1
ACT.dmg = 0
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 3
ACT.weaponMult = 1
ACT.ammoUse = 1 --how much ammo it uses
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "runngunshotgun"
ACT.name = "Run and Gun"
ACT.desc = "Move 1 AP distance and attack an enemy for only one AP cost."
ACT.category = "Gun"
ACT.restrict = true
ACT.attackString = "fires while moving at"
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.weaponMult = 1
ACT.multi = 8
ACT.ammoUse = 1 --how much ammo it uses
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "slug1"
ACT.name = "Slug (Shotgun)"
ACT.desc = "Fire a single slug."
ACT.attackString = "fires a slug at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 0
ACT.dmg = 28
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "slug2"
ACT.name = "Slug (Shotgun)"
ACT.desc = "Fire a single slug."
ACT.attackString = "fires a slug at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 0
ACT.dmg = 32
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "slug3"
ACT.name = "Slug (Shotgun)"
ACT.desc = "Fire a single slug."
ACT.attackString = "fires a slug at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 0
ACT.dmg = 38
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "slug4"
ACT.name = "Slug (Shotgun)"
ACT.desc = "Fire a single slug."
ACT.attackString = "fires a slug at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 0
ACT.dmg = 42
ACT.weaponMult = 1
ACT.accuracy = 0
ACT.accuracyMult = 1
ACT.multi = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "aimedshot_precision"
ACT.name = "Aimed Shot (Standard)"
ACT.desc = "Fire a single aimed shot at increased accuracy."
ACT.attackString = "fires an aimed shot at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.accuracy = 25
ACT.accuracyMult = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "aimedshot_shotgun"
ACT.name = "Aimed Shot (Standard)"
ACT.desc = "Fire a single aimed shot at increased accuracy."
ACT.attackString = "fires an aimed shot at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.accuracy = 25
ACT.accuracyMult = 1
ACT.dmg = 0
ACT.multi = 10
ACT.weaponMult = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)
--
--
local ACT = {}
ACT.uid = "aimedshot_sniper"
ACT.name = "Aimed Shot (Precision Rifle)"
ACT.desc = "Fire a single aimed shot at increased accuracy."
ACT.attackString = "fires an aimed shot at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.accuracy = 35
ACT.accuracyMult = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.ammoUse = 1 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "doubletap_revolver"
ACT.name = "Double Tap (Revolver)"
ACT.desc = "Fire two rounds with a slight accuracy penalty."
ACT.attackString = "fans the hammer at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -1
ACT.accuracyMult = 1
ACT.multi = 2
ACT.ammoUse = 2 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "minigun"
ACT.name = "Sustained Fire (Minigun)"
ACT.desc = "Fire a large spray of rounds at a target."
ACT.attackString = "fires a burst at"
ACT.category = "Gun"
ACT.costAP = 1
ACT.CD = 1
ACT.dmg = 0
ACT.weaponMult = 1
ACT.accuracy = -10
--ACT.accuracyMult = 0.55
ACT.multi = 10
ACT.critC = -10
ACT.ammoUse = 10 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACTS:Register(ACT)

--
local ACT = {}
ACT.uid = "suppression"
ACT.name = "Suppression"
ACT.desc = "Suppress a group of targets. (Consumes and fires 5 rounds.)"
ACT.attackString = "suppresses"
ACT.category = "Gun"
ACT.radius = 100
ACT.notarget = true
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0 --uncomment these if you want it to do damage
ACT.accuracy = -10
ACT.weaponMult = 1
ACT.multi = 5
ACT.critC = -9
ACT.ammoUse = 5 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Suppressed",
        effect = "suppressed",
        duration = 2,
        strength = 1,
		accuracyMult = 0.8, --multiplies accuracy by this number

        chance = 100,

        debuff = true,
    }
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "suppression1"
ACT.name = "Suppressive Fire"
ACT.desc = "Suppress a group of targets. (Consumes and fires 3 rounds.)"
ACT.attackString = "suppresses"
ACT.category = "Gun"
ACT.radius = 75
ACT.notarget = true
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0 --uncomment these if you want it to do damage
ACT.accuracy = -10
ACT.weaponMult = 1
ACT.multi = 3
ACT.critC = -9
ACT.ammoUse = 3 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Suppressed",
        effect = "suppressed",
        duration = 2,
        strength = 1,
		accuracyMult = 0.8, --multiplies accuracy by this number

        chance = 100,

        debuff = true,
    }
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "suppressionshotgun"
ACT.name = "Suppressive Fire"
ACT.desc = "Suppress a group of targets. (Consumes and fires 2 shells.)"
ACT.attackString = "suppresses"
ACT.category = "Gun"
ACT.radius = 75
ACT.notarget = true
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0 --uncomment these if you want it to do damage
ACT.accuracy = -10
ACT.weaponMult = 1
ACT.multi = 2
ACT.critC = -9
ACT.ammoUse = 2 --how much ammo it uses
ACT.restrict = true --if you don't put this anyone can use it
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Suppressed",
        effect = "suppressed",
        duration = 2,
        strength = 1,
		accuracyMult = 0.8, --multiplies accuracy by this number

        chance = 100,

        debuff = true,
    }
}
ACTS:Register(ACT)
--
local ACT = {}
ACT.uid = "suppressionpistol"
ACT.name = "Suppressive Fire"
ACT.desc = "Suppress a group of targets. (Consumes and fires 3 rounds.)"
ACT.attackString = "suppresses"
ACT.category = "Gun"
ACT.radius = 75
ACT.notarget = true
ACT.costAP = 1
ACT.CD = 2
ACT.dmg = 0 --uncomment these if you want it to do damage
ACT.accuracy = -12
ACT.weaponMult = 1
ACT.multi = 2
ACT.ammoUse = 2 --how much ammo it uses
ACT.critC = -9
ACT.restrict = true --if you don't put this anyone can use it
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Suppressed",
        effect = "suppressed",
        duration = 2,
        strength = 1,
		accuracyMult = 0.8, --multiplies accuracy by this number

        chance = 100,

        debuff = true,
    }
}
ACTS:Register(ACT)
--


local ACT
ACT = {}
ACT.uid = "overcharge"
ACT.name = "Overcharge"
ACT.desc = "Amp up the power on your energy weapon and fire a stronger shot."
ACT.category = "Energy Weapons"
ACT.restrict = true
ACT.attackString = "fires a beam at"
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1.5
ACTS:Register(ACT)
--

local ACT
ACT = {}
ACT.uid = "stun"
ACT.name = "Daze"
ACT.desc = "Throw a stunning attack."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "attempts to stun"
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Dazed",
        effect = "dazed",
        duration = 1,
        strength = 1,
		accuracyMult = 0.75, --multiplies accuracy by this number

        debuff = true,
    }
}
ACTS:Register(ACT)

--
local ACT
ACT = {}
ACT.uid = "sweep"
ACT.name = "Leg Sweep"
ACT.desc = "Attempt to sweep your opponent's legs out."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "attempts to sweep"
ACT.dmg = 0
ACT.CD = 2
ACT.weaponMult = 1.2
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Knockdown",
        effect = "knockdown",
        duration = 1,
        strength = 1,

        debuff = true,
    }
}
ACTS:Register(ACT)

--
local ACT
ACT = {}
ACT.uid = "charge"
ACT.name = "Charge"
ACT.desc = "Move 1 AP distance and attack an enemy."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "charges at"
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Off Balance",
        effect = "offbalance",
        duration = 1,
        strength = 1,
		evasion = -25,
		
		selfApply = true,
		debuff = true,
    }
}
ACTS:Register(ACT)

--
local ACT
ACT = {}
ACT.uid = "tackle"
ACT.name = "Tackle"
ACT.desc = "Move 1 AP distance and tackle an enemy."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "tackles"
ACT.CD = 2
ACT.dmg = 0
ACT.weaponMult = 1
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Knockdown",
        effect = "knockdown",
        duration = 1,
        strength = 1,

        debuff = true,
    },
	[2] = {
        uid = ACT.uid,

        name = "Off Balance",
        effect = "offbalance",
        duration = 1,
        strength = 1,
		evasion = -25,
		
		selfApply = true,
		debuff = true,
    }
}
ACTS:Register(ACT)

--


local ACT
ACT = {}
ACT.uid = "sting"
ACT.name = "Envenomation"
ACT.desc = "Attack an enemy with venom."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "stings at"
ACT.CD = 2
ACT.dmg = 30
ACT.dmgT = "Slash"
ACT.effects = {
	[1] = {
		uid = ACT.uid,
		
		name = "Envenomated",
		effect = "venom",
		duration = 8,
		dmg = 8,
		dmgT = "Venom",
		strength = 1,

		debuff = true,
	}
}
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "heavyattack"
ACT.name = "Heavy Attack"
ACT.desc = "Exert extra power in a particularly wide swing."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "swings at"
ACT.CD = 2
ACT.dmg = 10
ACT.weaponMult = 1.5
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "bodyslam"
ACT.name = "Bodyslam"
ACT.desc = "Grab your enemy and slam them on the ground. Or throw your body weight at your enemy."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "bodyslams"
ACT.CD = 2
ACT.weaponMult = 1.25
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Knockdown",
        effect = "knockdown",
        duration = 1,
        strength = 1,

        debuff = true,
    }
}

ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "wideswing"
ACT.name = "Wide Swing"
ACT.desc = "Attack in a large area around you."
ACT.category = "Melee"
ACT.restrict = true
ACT.attackString = "swings around themselves at"
ACT.CD = 2
ACT.dmg = 5
ACT.dmgT = "Slash"
ACT.weaponMult = 1
ACT.weaponMult = 1
ACT.radius = 150 
ACT.selfOnly = true
ACT.noSelf = true
ACT.notarget = false
ACTS:Register(ACT)
--
--

local ACT
ACT = {}
ACT.uid = "charisma3"
ACT.name = "Empower"
ACT.desc = "Spend 1 AP to empower an ally. ((Buff 1.25x Evasion for one turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "empowers"
ACT.CD = 2
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 3,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Empowered",
        effect = "empowered",
        duration = 1,
        strength = 1,
		evasionMult = 1.25,
        buff = true,
    }
}
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "charisma4"
ACT.name = "Pick Target"
ACT.desc = "Spend 1 AP to point out an enemy. ((Debuff 1.25x Evasion for one turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "points out"
ACT.CD = 2
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 4,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Targetted",
        effect = "cha",
        duration = 1,
        strength = 1,
		evasionMult = 0.75, --multiplies accuracy by this number
        debuff = true,
    }
}
ACTS:Register(ACT)

--
local ACT
ACT = {}
ACT.uid = "charisma5"
ACT.name = "Rally"
ACT.desc = "Spend 1 AP to empower a group of allies. ((AOE Buff 1.25x Accuracy for one turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "rallies"
ACT.CD = 2
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 5,
}
ACT.notarget = true
ACT.radius = 200 
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Rally",
        effect = "rally",
        duration = 1,
        strength = 1,
		accuracyMult = 1.25, --multiplies accuracy by this number
        buff = true,
    }
}
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "charisma5accdebuff"
ACT.name = "Warcry"
ACT.desc = "Spend 1 AP to intimidate a group of enemies. ((AOE Debuff 1.25x Accuracy for one turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "intimidates"
ACT.CD = 2
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 5,
}
ACT.notarget = true
ACT.radius = 200 
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Intimidate",
        effect = "intimidate",
        duration = 1,
        strength = 1,
		accuracyMult = 0.75, --multiplies accuracy by this number
        debuff = true,
    }
}
ACTS:Register(ACT)
--

local ACT
ACT = {}
ACT.uid = "charisma6"
ACT.name = "Haste"
ACT.desc = "Encourage a teammate to take action. ((+1 AP for a turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "hastens"
ACT.CD = 5
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 6,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Hasten",
        effect = "hastened",
        duration = 0,
        strength = 1,
		maxAP = 1,
        buff = true,
    }
}
ACTS:Register(ACT)


--

local ACT
ACT = {}
ACT.uid = "charisma7"
ACT.name = "Pacify"
ACT.desc = "Spend 1 AP to convince your enemy to stand down, or run away."
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "tries to pacify"
ACT.CD = 2
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 7,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Pacified",
        effect = "pacified",
        duration = 1,
        strength = 1,
        chance = 55,
        debuff = true,
    }
}
ACTS:Register(ACT)

--

local ACT
ACT = {}
ACT.uid = "charisma8"
ACT.name = "Command"
ACT.desc = "Seize control of the fight and organize your allies to do more. ((+1 AP for a turn.))"
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "hastens"
ACT.CD = 5
ACT.costAP = 1
ACT.reqStats = {
	["cha"] = 8,
}
ACT.notarget = true
ACT.radius = 200 
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Hasten",
        effect = "hastened",
        duration = 0,
        strength = 1,
		maxAP = 1,
        buff = true,
    }
}
ACTS:Register(ACT)

--

local ACT = {}
ACT.uid = "charisma9"
ACT.name = "Vigilant"
ACT.desc = "Warn your ally of incoming danger, allowing them to dodge one attack for the next turn."
ACT.attackString = "warns"
ACT.category = "Charisma"
ACT.costAP = 1
ACT.CD = 4
ACT.restrict = false
ACT.hidden = true
ACT.reqStats = {
	["cha"] = 9,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Watchful",
        effect = "watchful",
        duration = 1,
        strength = 1,

		evasion = 200,

		hitsDef = 1,
		
		selfApply = true,
		buff = true,
    }
}
ACTS:Register(ACT)

--
local ACT
ACT = {}
ACT.uid = "charisma10"
ACT.name = "Subjugate"
ACT.desc = "Attempt to convince a group to surrender."
ACT.category = "Charisma"
ACT.restrict = false
ACT.hidden = true
ACT.attackString = "tries to pacify"
ACT.CD = 2
ACT.costAP = 1
ACT.notarget = true
ACT.radius = 200 
ACT.reqStats = {
	["cha"] = 10,
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Pacified",
        effect = "pacified",
        duration = 1,
        strength = 1,
        chance = 55,
        debuff = true,
    }
}
ACTS:Register(ACT)

--
--

local ACT = {}
ACT.uid = "block1"
ACT.name = "Block Level 1"
ACT.desc = "Provides a massive armor boost against the next 5 incoming hits, last one turn."
ACT.attackString = "prepares to block"
ACT.category = "Melee"
ACT.costAP = 1
ACT.CD = 1
ACT.restrict = true
ACT.selfOnly = true
ACT.notarget = true
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Blocking",
        effect = "blocking",
        duration = 1,
        strength = 1,

		armor = 200,

		hitsDef = 5,
		
		selfApply = true,
		buff = true,
    }
}
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "block2"
ACT.name = "Block Level 2"
ACT.desc = "Provides a massive armor boost against the next 6 incoming hits, last one turn."
ACT.attackString = "prepares to block"
ACT.category = "Melee"
ACT.costAP = 1
ACT.CD = 1
ACT.restrict = true
ACT.selfOnly = true
ACT.notarget = true
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Blocking",
        effect = "blocking",
        duration = 1,
        strength = 1,

		armor = 200,

		hitsDef = 6,
		
		selfApply = true,
		buff = true,
    }
}
ACTS:Register(ACT)
--

local ACT = {}
ACT.uid = "block3"
ACT.name = "Block Level 3"
ACT.desc = "Provides a massive armor boost against the next 7 incoming hits, last one turn."
ACT.attackString = "prepares to block"
ACT.category = "Melee"
ACT.costAP = 1
ACT.CD = 1
ACT.restrict = true
ACT.selfOnly = true
ACT.notarget = true
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Blocking",
        effect = "blocking",
        duration = 1,
        strength = 1,

		armor = 200,

		hitsDef = 7,
		
		selfApply = true,
		buff = true,
    }
}
ACTS:Register(ACT)
--





--[[
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Suppressed",
        effect = "suppress",
        duration = 1,
        strength = 1,

		accuracyMult = 0.5, --multiplies accuracy by this number

        debuff = true,
    }
}
ACT.effects = {
    [1] = {
        uid = ACT.uid,

        name = "Dodging",
        effect = "dodging",
        duration = 1,
        strength = 1,

		evasionMult = 1.5, --multiplies accuracy by this number

        debuff = true,
    }
}
--]]