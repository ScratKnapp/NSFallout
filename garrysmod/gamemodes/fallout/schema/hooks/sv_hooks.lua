--[[
local workshopIDs = { 
132470017, --lantern
121438260, --glowsticks
415143062, --tfa base
296202013, --prosp content 1
575907820, --prosp content decals
795055947, --blood and gore 4
479464165, --pac gear
160250458, --wire
380225333, --nextbot zombies 2.0
296806391, --nextbot zombies 2.0 (zombie survival)
246756300, --3d stream radio
609281761, --prone mod models
106867422, --classic light stool
727161410, --witcher gates
685130934, --serverguard content
774729099, --respite npc content
1450252748, --respite extra content
771487490, --simfphys vehicles
831680603, --simfphys armed vehicles
207739713, --nutscript content
880425071, --respite content 1
880423690, --respite content 2
880417421, --respite content 3
899354382, --respite effects
1076723138, --tfa content 1
1076732010, --tfa content 2
1076706011, --tfa content 3
756545326, --gunsmoke community models

--player models

760262099, --tnb 1
760268522, --tnb 3
760265535, --tnb 2
873882787, --tnb 4
760255843, --tnb items
760256673, --tnb combine


--Temporary Things (Like Maps)

215338015, --rp_v_torrington content
1612000229 --woodland warzone
}


for k, v in pairs(workshopIDs) do
	resource.AddWorkshop(v)
end
--]]

--resource.AddFile("resource/fonts/IMMORTAL.ttf")
--resource.AddFile("maps/rp_cyberpunk_2120_d.bsp")

-- Enforce a floor of 1 on every attribute and skill at character creation,
-- filling in any the client left out so no stat is ever stored at 0. This runs
-- after the framework's point-pool validation (see multichar sv_networking's
-- nutCharCreate handler), so the minimums apply regardless of how the player
-- distributed their creation points.
function SCHEMA:AdjustCreationData(client, data, newData, originalData)
	local attribs = istable(data.attribs) and data.attribs or {}
	for id in pairs(nut.attribs.list) do
		attribs[id] = math.max(attribs[id] or 0, 1)
	end
	data.attribs = attribs

	local skills = istable(data.skills) and data.skills or {}
	for id in pairs(nut.skills.list) do
		skills[id] = math.max(skills[id] or 0, 1)
	end
	data.skills = skills
end

function SCHEMA:OnCharCreated(client, character)
	local inventory = character:getInv()

	if (inventory) then	
		inventory:add("aetherstonepda", 1)
	end
end 

--if players can spawn effect props or not
function SCHEMA:PlayerSpawnEffect(client, weapon, info)
	return client:IsAdmin() or client:getChar():hasFlags("E")
end

--turns off sprays
function SCHEMA:PlayerSpray(client)
    return true
end

function SCHEMA:Initialize()
	game.ConsoleCommand("net_maxfilesize 64\n");
	game.ConsoleCommand("sv_kickerrornum 0\n");

	game.ConsoleCommand("sv_allowupload 0\n");
	game.ConsoleCommand("sv_allowdownload 1\n");
	game.ConsoleCommand("sv_allowcslua 0\n");
end

function SCHEMA:PostPlayerLoadout(client)
	-- Reload All Attrib Boosts
	local char = client:getChar()

	if (char:getInv()) then
		for k, v in pairs(char:getInv():getItems()) do
			v:call("onLoadout", client)

			if (v:getData("equip", false) and (v.attribs or v.attribBoosts or v:getData("attrib"))) then
				timer.Simple(1, function()
					if(v.buffRefresh) then
						v.buffRefresh(v, client)
					end
				end)
			end
		end
	end
end

function SCHEMA:PlayerSpawnRagdoll(client)
	if(client and client:IsPlayer()) then
		if (client:getChar() and client:getChar():hasFlags("r")) then
			return true
		end

		return false
	end
end

--someone gave me this, I don't know if it really helps or not but it's supposed to make sure the server doesn't lose connection to db
function SCHEMA:Think()
	if((self.NextDBRefresh or 0) < CurTime()) then
		nut.db.query("SELECT 1 + 1", onSuccess)
			
		self.NextDBRefresh = CurTime() + 10
	end
end