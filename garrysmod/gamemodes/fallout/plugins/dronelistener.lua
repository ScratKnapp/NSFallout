local PLUGIN = PLUGIN
PLUGIN.name = "Drone Chat Listening"
PLUGIN.author = "Seamus"
PLUGIN.desc = "Allows players in drones to hear most chat messages around them."

--this plugin require modifications to sh_chatbox to work

function PLUGIN:onCanHear(range, speaker, listener)
	local listenerDrone = listener.drone
	local speakerDrone = listener.drone

	if(listenerDrone and IsValid(listenerDrone)) then
		if(listenerDrone:GetNWEntity("DronesRewriteDriver", "") == listener) then
			if (speaker:GetPos() - listenerDrone:GetPos()):LengthSqr() <= range then
				return true
			end
		end
	end
	
	if(speakerDrone and IsValid(speakerDrone)) then
		if(speakerDrone:GetNWEntity("DronesRewriteDriver", "") == speaker) then
			if (listener:GetPos() - speakerDrone:GetPos()):LengthSqr() <= range then
				return true
			end
		end
	end
end