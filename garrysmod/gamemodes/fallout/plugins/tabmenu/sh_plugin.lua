local PLUGIN = PLUGIN
PLUGIN.name = "Tab Menu"
PLUGIN.author = " "
PLUGIN.desc = "A menu that shows up upon pressing tab."

if(CLIENT) then
	function PLUGIN:PlayerBindPress(client, bind, pressed)
		if (bind:lower():find("score") and pressed) then
			if (IsValid(nut.gui.menu)) then
				nut.gui.menu:remove()
			elseif (LocalPlayer():getChar()) then
				vgui.Create("nutMenuBox")
			end
			
			return true
		end
	end
end