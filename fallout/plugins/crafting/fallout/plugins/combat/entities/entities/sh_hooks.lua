local PLUGIN = PLUGIN

function ENT:onSelected(client)
	if(CLIENT) then
		surface.PlaySound("vo/npc/male01/squad_follow0" ..math.random(2,3).. ".wav")
		self.selected = true
	else
		
	end
end

function ENT:onActionSelect(client, action)

end

function ENT:onDeselected(client)
	if(CLIENT) then
		--surface.PlaySound("vo/npc/male01/squad_follow0" ..math.random(2,3).. ".wav")
		self.selected = nil
	else
		
	end
end