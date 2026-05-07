local PLUGIN = PLUGIN
PLUGIN.name = "Character Notes"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Let's admins add notes to characters"

if(SERVER) then
	function PLUGIN:openNotes(client, target, edit)
		if(IsValid(target) and target:getChar()) then
			local charID = target:getChar():getID()
			
			local path = "nutscript/"..SCHEMA.folder.."/charnotes/" ..charID.. ".txt"
		
			local charNote = file.Read(path) or ""

			--sends them gui thing
			netstream.Start(client, "nut_charNoteOpen", charID, charNote, edit)
		end
	end
	
	function PLUGIN:LoadData()
		local path = "nutscript/"..SCHEMA.folder.."/charnotes/"
		if(!file.Exists(path, "DATA")) then
			file.CreateDir("nutscript/"..SCHEMA.folder.."/charnotes/")
		end
	end
	
	netstream.Hook("nut_charNoteSave", function(client, charID, notes)
		local path = "nutscript/"..SCHEMA.folder.."/charnotes/" ..charID.. ".txt"
		file.Write(path, notes)
	end)
else
	netstream.Hook("nut_charNoteOpen", function(charID, notes, edit)
		local noteFrame = vgui.Create("DFrame")
		noteFrame:SetTitle("Character Notes")
		noteFrame:SetSize(400, 400)
		noteFrame:SetPos(ScrW() * 0.5, ScrH() * 0.5)
		noteFrame:Center()
		noteFrame:MakePopup()
		noteFrame:ShowCloseButton(true)

		local scroll = vgui.Create("DScrollPanel", noteFrame)
		scroll:Dock(FILL)
	
		local notesGUI = vgui.Create("DTextEntry", scroll)
		notesGUI:DockMargin(0, 8, 0, 0)
		notesGUI:SetSize(160, ScrH() * 0.2)
		notesGUI:Dock(FILL)
		notesGUI:SetFont("nutCharSubTitleFont")
		notesGUI:SetTextColor(Color(255,255,255))
		notesGUI:SetVerticalScrollbarEnabled(true)
		notesGUI:SetText(notes or "")
		notesGUI:SetPaintBackground(false)
		notesGUI:SetWrap(true)
		notesGUI:SetMultiline(true)
		notesGUI:SetEditable(true)

		if(edit) then
			local notesGUIB = vgui.Create("DButton", noteFrame)
			notesGUIB:SetText("Save")
			notesGUIB:SetSize(20, 100)
			--notesGUIB:SetPos(ScrW() * 0.5, ScrH() * 0.6)
			notesGUIB:Dock(BOTTOM)
			notesGUIB.DoClick = function()
				netstream.Start("nut_charNoteSave", charID, notesGUI:GetText())
				
				noteFrame:Remove()
			end
		else
			--notesGUI:SetEditable(false)
			notesGUI:SetEnabled(false)
		end
	end)
end

nut.command.add("viewnotes", {
	onRun = function(client, arguments)
		PLUGIN:openNotes(client, client, false)
	end
})

nut.command.add("adminnotes", {
	adminOnly = true,
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])	
		if(target) then
			PLUGIN:openNotes(client, target, true)
		end
	end
})