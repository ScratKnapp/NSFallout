AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Puzzle Box"
ENT.Author			= "Seamus"
ENT.Contact			= "Seamus#5576"
ENT.Purpose			= "Serves as a host for the puzzle."
ENT.Instructions	= "Press E and think."
ENT.Category 		= "NutScript"

if SERVER then

	function ENT:Initialize()
		self:SetModel( "models/props_lab/reciever01b.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	 
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	 
	function ENT:Use( activator, caller )
		if nut.plugin.list["puzzlebox"].winner then
			activator:notify("The puzzle has already been solved.")
			return
		end
	
		if activator:getChar():getData("puzzleweek1",0) + 43200 > os.time() then
			activator:notify("You're trying again too soon. You can try every 12 hours.")
			return
		end
		
		if !nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] then
			nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] = 0
		end
	
		activator:requestString("Direction", "Input the direction you want to go (N,E,S,W).", function(text)
			text = string.lower(text)
			
			if string.len(text) != 1 then
				activator:notify("Only put one letter.")
				return
			end
			
			if string.match(text,"n") or string.match(text,"e") or string.match(text,"s") or string.match(text,"w") then
				if text == nut.plugin.list["puzzlebox"].presetPath[nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()]+1] then
					nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] = nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] + 1
					if nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] == #nut.plugin.list["puzzlebox"].pathTable then
						activator:notify("Correct. You've completed the puzzle box.")
						activator:getChar():getInv():add("quest", 1, {
							custom = {
								name = "Week 1 Key",
								desc = "A small key that looks like a lever, it has numerous engravings, notably the Roman Numeral for one.",
								model = "models/props_c17/TrapPropeller_Lever.mdl",
							}
						})
						for k,v in pairs(player.GetAll()) do
							if v:IsAdmin() then
								v:notify(activator:GetName().." has completed week one of the puzzle box.")
								nut.plugin.list["puzzlebox"].winner = activator:GetName()
							end
						end
					else
						activator:notify("Correct.")
					end
				else
					activator:notify("Incorrect. Try again in 12 hours.")
					nut.plugin.list["puzzlebox"].directionStages[activator:SteamID64()] = 0
					activator:getChar():setData("puzzleweek1",os.time())
				end
			else
				activator:notify("Put one of the letters of the directions. (n,e,s,w)")
			end
		end,"")
	end
	
else
	function ENT:Draw()
		self:DrawModel()
	end
end