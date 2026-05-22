-- CYR Combat Log - Server Side
-- Hooks EntityTakeDamage and sends combat events to players
if CLIENT then return end
netstream.Hook("cyrCombatLog", function() end) -- Register empty hook so netstream knows about it
hook.Add("EntityTakeDamage", "CYR_CombatLog", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    local amount = math.ceil(dmginfo:GetDamage())
    if amount <= 0 then return end
    -- Determine damage type string
    local dmgType = "Physical"
    local dmgFlags = dmginfo:GetDamageType()
    if bit.band(dmgFlags, DMG_BURN) > 0 then
        dmgType = "Fire"
    elseif bit.band(dmgFlags, DMG_SHOCK) > 0 then
        dmgType = "Shock"
    elseif bit.band(dmgFlags, DMG_BLAST) > 0 then
        dmgType = "Explosion"
    elseif bit.band(dmgFlags, DMG_FALL) > 0 then
        dmgType = "Fall"
    elseif bit.band(dmgFlags, DMG_SLASH) > 0 then
        dmgType = "Slash"
    elseif bit.band(dmgFlags, DMG_CLUB) > 0 then
        dmgType = "Blunt"
    elseif bit.band(dmgFlags, DMG_BULLET) > 0 then
        dmgType = "Bullet"
    elseif bit.band(dmgFlags, DMG_DROWN) > 0 then
        dmgType = "Drowning"
    elseif bit.band(dmgFlags, DMG_POISON) > 0 then
        dmgType = "Poison"
    end

    local attackerName = "World"
    if IsValid(attacker) then
        if attacker:IsPlayer() then
            local char = attacker.getChar and attacker:getChar()
            attackerName = char and char:getName() or attacker:Name()
        else
            attackerName = attacker:GetClass()
            -- Clean NPC names
            attackerName = attackerName:gsub("^npc_", ""):gsub("_", " ")
            -- Capitalize first letter
            attackerName = attackerName:sub(1, 1):upper() .. attackerName:sub(2)
        end
    end

    local targetName = "Unknown"
    if IsValid(target) then
        if target:IsPlayer() then
            local char = target.getChar and target:getChar()
            targetName = char and char:getName() or target:Name()
        else
            targetName = target:GetClass():gsub("^npc_", ""):gsub("_", " ")
            targetName = targetName:sub(1, 1):upper() .. targetName:sub(2)
        end
    end

    -- Send to victim (damage taken)
    if IsValid(target) and target:IsPlayer() then
        netstream.Start(target, "cyrCombatLog", {
            type = "damage-taken",
            text = attackerName .. " hit you (" .. dmgType .. ")",
            amount = amount
        })
    end

    -- Send to attacker (damage dealt)
    if IsValid(attacker) and attacker:IsPlayer() and attacker ~= target then
        netstream.Start(attacker, "cyrCombatLog", {
            type = "damage-dealt",
            text = "You hit " .. targetName .. " (" .. dmgType .. ")",
            amount = amount
        })
    end
end)

-- Also hook healing if ACTIS or custom heal system exists
hook.Add("PlayerHealthChanged", "CYR_CombatLog_Heal", function(ply, oldHP, newHP)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local diff = newHP - oldHP
    if diff > 0 then
        netstream.Start(ply, "cyrCombatLog", {
            type = "heal",
            text = "Health restored",
            amount = diff
        })
    end
end)

print("[CYR] Combat Log server module loaded!")