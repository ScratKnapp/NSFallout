local PLUGIN = PLUGIN

EFFS = {}
EFFS.effects = {}
function EFFS:Register(tbl)
	self.effects[tbl.uid] = tbl
end
	
local EFF = {}
EFF.uid = "hack"
EFF.name = "Hack"
EFF.desc = "Technology related hack."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	return "HACKED"
end

EFFS:Register(EFF)

local EFF = {}
EFF.uid = "emp"
EFF.name = "EMP"
EFF.desc = "Electro-magnetic Pulse"
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	return "EMP"
end

EFFS:Register(EFF)

local EFF = {}
EFF.uid = "stun"
EFF.name = "Stun"
EFF.desc = "Prevents effected target from doing anything."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	target:setNetVar("ap", 0)
	--]]
	
	return "STUNNED"
end

EFFS:Register(EFF)	
local EFF = {}
EFF.uid = "stop"
EFF.name = "Stop"
EFF.desc = "Prevents effected target from doing anything."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	target:setNetVar("ap", 0)
	--]]
	
	return "STOPPED"
end

EFFS:Register(EFF)	
local EFF = {}
EFF.uid = "slow"
EFF.name = "Slow"
EFF.desc = "Reduces target's AP."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	amount = {1, 0.1},
	chance = 100,
}
EFF.func = function(target, effect)
	return "SLOWED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "root"
EFF.name = "Root"
EFF.desc = "Restricts a target's movement, but they can still attack (if in range)."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 7},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	return "ROOTED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "blind"
EFF.name = "Blind"
EFF.desc = "Robs the target of their vision."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	amount = {50, 0.2},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["foresight"] = 1 - (effect.severity or 0),
		["duration"] = 1
	}
	--]]
	
	return "BLINDED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "sleep"
EFF.name = "Sleep"
EFF.desc = "Puts a target to sleep. If the target takes enough damage, they are awoken."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 8},
	strength = {1, 1},
	amount = {10, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	target:setNetVar("ap", 0)
	--]]
	
	return "SLEEP"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "confuse"
EFF.name = "Confuse"
EFF.desc = "Confuses a target, possibly causing it to make poor decisions."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 5},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "CONFUSED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "charm"
EFF.name = "Charm"
EFF.desc = "Convinces a target to view you more favorably."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 11},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	return "CHARMED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "disarm"
EFF.name = "Disarm"
EFF.desc = "Prevents a target from using basic and martial attacks."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 7},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["attack"] = 0,
		["duration"] = 1
	}
	--]]
	
	return "DISARMED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "fear"
EFF.name = "Fear"
EFF.desc = "Cause the target to be filled with fear."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "FEAR"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "dot"
EFF.name = "Damage Over Time (DOT)"
EFF.desc = "Deal damage over time to a target."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	dmg = {1, 0.6},
	--dmgType = 1,
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	target:receiveDamage(effect.damage or 0, effect.damageType or "Physical")
	--]]
	
	return "DOT"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "statdecrease"
EFF.name = "Decrease Attribute"
EFF.desc = "Decrease target's specified attribute."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	
	buffs[self.uid..math.random(1,100)] = {
		["attribs"] = effect.attribs,
		["duration"] = 1
	}
	--]]
	
	return "STATS DECREASED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "pain"
EFF.name = "Pain"
EFF.desc = "Cause a target great pain, potentially interrupting their focus."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["duration"] = 1
	}
	--]]

	return "PAIN"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "reduceres"
EFF.name = "Reduce Resistance"
EFF.desc = "Reduce target's resistance to a specified damage type."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	local res = target.res
	
	for k, buff in pairs(effect.res) do
		res[k] = (res[k] or 1) + buff
	end
	
	buffs[self.uid..math.random(1,100)] = {
		["res"] = res,
		["duration"] = 1
	}
	--]]
	
	return "REDUCED RESISTANCES"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "movetarget"
EFF.name = "Move (Target)"
EFF.desc = "Move target in some direction or to some place."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "MOVED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "taunt"
EFF.name = "Taunt"
EFF.desc = "Attract the attention of target, causing them to focus on you."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 9},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "TAUNTED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "weak"
EFF.name = "Weaken"
EFF.desc = "Reduce target's damage of a specified damage type."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	--dmgType = 1,
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	local dmgType = {}
	
	for k, v in pairs(effect.dmgTypes) do
		dmgType[k] = 1 - v
	end
	
	buffs[self.uid..math.random(1,100)] = {
		["dmgType"] = dmgType,
		["duration"] = 1
	}
	--]]
	
	return "WEAKENED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "bleed"
EFF.name = "Bleed"
EFF.desc = "Cause target to bleed."
EFF.category = "negative"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	dmg = {1, 1},
	---dmgType = 1,
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	target:receiveDamage(effect.damage or 0, effect.damageType or "Direct")
	--]]
	
	return "BLEED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "purge"
EFF.name = "Purge Buff"
EFF.desc = "Purges (removes) buffs from a target."
EFF.category = "negative"
EFF.attribs = {
	--duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	local buffs = target:getBuffs()
	for k, buff in pairs(buffs) do
		if(buff.buff and buff.strength and (buff.strength <= (effect.strength or 0))) then
			target:removeBuff(buff, buff.uid)
		end
	end

	return "PURGED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "purgedebuff"
EFF.name = "Purge Debuff"
EFF.desc = "Purges (removes) debuffs from a target."
EFF.category = "positive"
EFF.attribs = {
	--duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	local buffs = target:getBuffs()
	for k, buff in pairs(buffs) do
		if(buff.debuff and buff.strength and (buff.strength <= (effect.strength or 0))) then
			target:removeBuff(buff, buff.uid)
		end
	end

	return "PURGED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "Haste"
EFF.name = "haste"
EFF.desc = "Increases a target's AP."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	amount = {1, 5},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["ap"] = effect.ap,
		["duration"] = 1
	}
	--]]

	return "HASTED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "statincrease"
EFF.name = "Increase Attribute"
EFF.desc = "Increases a target's specified attribute."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	local buffs = target.buffs or {}

	buffs[self.uid..math.random(1,100)] = {
		["attribs"] = effect.attribs,
		["duration"] = 1
	}
	--]]
	
	return "STATS INCREASED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "resincrease"
EFF.name = "Increase Resistance"
EFF.desc = "Increases a target's specified resistance."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	local buffs = target.buffs or {}
	local res = target.res
	
	for k, buff in pairs(effect.res) do
		res[k] = (res[k] or 1) + buff
	end
	
	buffs[self.uid..math.random(1,100)] = {
		["res"] = res,
		["ap"] = 1,
		["duration"] = 1,
	}
	--]]
	
	return "RESISTANCES INCREASED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "heal"
EFF.name = "Heal"
EFF.desc = "Heals a target's health."
EFF.category = "positive"
EFF.attribs = {
	--duration = {1, 10},
	amount = {1, 2},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	local hp = target:getNetVar("hp", target.hp) or 0
	if(hp > (target.hp or 0)) then
		hp = hp + effect.healing
	end
	--]]
	
	return "HEALED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "regen"
EFF.name = "Regeneration"
EFF.desc = "Heals a target's health per turn."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 3},
	strength = {1, 1},
	amount = {1, 1.5},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	local hp = target:getNetVar("hp", target.hp) or 0
	if(hp > (target.hp or 0)) then
		hp = hp + effect.healing
	end
	--]]
	
	return "REGENERATED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "maxhp"
EFF.name = "Max Health Increase"
EFF.desc = "Increases a target's max health, does not heal them."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	amount = {1, 2},
	chance = 100,
}
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "armor"
EFF.name = "Armor"
EFF.desc = "Applies armor to a target."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	amount = {1, 0.5},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["armor"] = effect.armor,
		["duration"] = 1
	}
	--]]

	return "ARMORED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "moveself"
EFF.name = "Move (Self)"
EFF.desc = "Moves self in specified direction or to specified location."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 10},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "MOVED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "augmenteq"
EFF.name = "Augment Equipment"
EFF.desc = "Increases damage of specified weapon for a certain amount of hits."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["attack"] = effect.damage,
		["duration"] = 1
	}
	--]]
	
	return "AUGMENTED (WEAPON)"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "invis"
EFF.name = "Invisibility"
EFF.desc = "Makes the target invisible."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	chance = 100,
}
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "mask"
EFF.name = "Mask"
EFF.desc = "Hides or disguises target from inspection."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 4},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["duration"] = 1
	}
	--]]
	
	return "INVISIBILITY"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "strengthen"
EFF.name = "Strengthen"
EFF.desc = "Increases target's damage of a specified damage type."
EFF.category = "positive"
EFF.attribs = {
	duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	--[[
	local buffs = target.buffs or {}
	buffs[self.uid..math.random(1,100)] = {
		["dmgType"] = effect.dmgTypes,
		["duration"] = 1
	}
	--]]
	
	return "STRENGTHENED"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "dispel1"
EFF.name = "Dispel"
EFF.desc = "Removes debuffs from a target."
EFF.category = "positive"
EFF.attribs = {
	--duration = {1, 10},
	strength = {1, 1},
	chance = 100,
}
EFF.func = function(target, effect) --todo
	return "Dispelled"
end
EFFS:Register(EFF)

local EFF = {}
EFF.uid = "hploss"
EFF.name = "Health Loss"
EFF.desc = "Reduces caster's health."
EFF.category = "other"
EFF.attribs = {
	amount = {1, -0.5},
	chance = 100,
}
EFF.func = function(target, effect)
	--[[
	local hp = target:getNetVar("hp", target.hp) or 0
	if(hp > 0) then
		hp = hp - effect.hp
	end
	
	target:setNetVar("hp", hp)
	--]]
	
	return "HP LOST"
end
EFFS:Register(EFF)