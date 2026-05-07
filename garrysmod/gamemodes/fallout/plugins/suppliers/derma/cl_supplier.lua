local PLUGIN = PLUGIN

local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.supplier)) then
			nut.gui.supplier:Remove()
		end
		
		nut.gui.supplier = self
		
		--self.items = {}

		self:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		self:Center()
		self:SetTitle("")
		self:MakePopup()

		local inner = vgui.Create("DPanel", self)
		inner:Dock(FILL)
		
		self.scroll = vgui.Create("DScrollPanel", inner)
		self.scroll:Dock(FILL)
		self.scroll:SetPaintBackground(true)
		self.scroll:SetBackgroundColor(Color(100,200,100))
		self.scroll:DockMargin(5, 5, 5, 5)
		
		local vBar = self.scroll:GetVBar()
		function vBar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		end
		function vBar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		function vBar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
		end
		
		self.Paint = function(panel, w, h)
			--background image
			surface.SetDrawColor(Color(40, 40, 40, 255))
			surface.DrawRect(0, 0, w, h)
		end
	end
	
	function PANEL:LoadSupplier(entity)
		self.entity = entity
		self.entries = {}
	
		local scroll = self.scroll
	
		local name = entity:GetName() or ""
		local shipmentName = entity:GetShipmentName() or ""
		local model = entity:GetModel() or ""
		local material = entity:GetMaterial() or ""
		local cost = entity:GetCost() or ""
		local cd = entity:GetCD() or ""
		local trait = entity:GetTrait() or ""
		local random = entity:GetRandom() or false
		local randomAmt = entity:GetRandomAmt() or 1
		
		self.shipment = entity:GetShipment() or ""
	
		--name
		local nameL = vgui.Create("DLabel", scroll)
		nameL:SetText("Name:")
		nameL:Dock(TOP)

		local nameC = vgui.Create("DTextEntry", scroll)
		nameC:SetText(name)
		nameC:Dock(TOP)
		self.entries["name"] = nameC 
		
		--shipment name
		local shipNameL = vgui.Create("DLabel", scroll)
		shipNameL:SetText("Shipment Name:")
		shipNameL:Dock(TOP)

		local shipNameC = vgui.Create("DTextEntry", scroll)
		shipNameC:SetText(shipmentName)
		shipNameC:Dock(TOP)
		self.entries["shipmentName"] = shipNameC 
		
		--model
		local modelL = vgui.Create("DLabel", scroll)
		modelL:SetText("Model:")
		modelL:Dock(TOP)

		local modelC = vgui.Create("DTextEntry", scroll)
		modelC:SetText(model)
		modelC:Dock(TOP)
		self.entries["model"] = modelC 
		
		--material
		local materialL = vgui.Create("DLabel", scroll)
		materialL:SetText("Material:")
		materialL:Dock(TOP)

		local materialC = vgui.Create("DTextEntry", scroll)
		materialC:SetText(material)
		materialC:Dock(TOP)
		self.entries["material"] = materialC 
		
		--cost
		local costL = vgui.Create("DLabel", scroll)
		costL:SetText("Cost:")
		costL:Dock(TOP)

		local costC = vgui.Create("DTextEntry", scroll)
		costC:SetText(cost)
		costC:Dock(TOP)
		self.entries["cost"] = costC 
		
		--cd (in days)
		local cdL = vgui.Create("DLabel", scroll)
		cdL:SetText("Cooldown (Days):")
		cdL:Dock(TOP)

		local cdC = vgui.Create("DTextEntry", scroll)
		cdC:SetText(cd)
		cdC:Dock(TOP)
		self.entries["cd"] = cdC
		
		--trait
		local traitL = vgui.Create("DLabel", scroll)
		traitL:SetText("Trait:")
		traitL:Dock(TOP)

		local traitC = vgui.Create("DComboBox", scroll)
		traitC:SetText(trait)
		traitC:Dock(TOP)
		
		for k, v in pairs(TRAITS.traits) do
			traitC:AddChoice(v.name, v.uid)
		end
		self.entries["trait"] = traitC
		
		local randomC = vgui.Create("DCheckBoxLabel", scroll)
		randomC:Dock(TOP)
		randomC:SetText("Randomized")
		randomC:SetChecked(random)	
		self.entries["random"] = randomC
		
		--Random Amount
		local randomAL = vgui.Create("DLabel", scroll)
		randomAL:SetText("Random Item Amount:")
		randomAL:Dock(TOP)

		local randomAC = vgui.Create("DTextEntry", scroll)
		randomAC:SetText(randomAmt)
		randomAC:Dock(TOP)
		self.entries["randomAmt"] = randomAC
		
		--shipment customization
		local shipment = vgui.Create("DButton", scroll)
		shipment:SetText("Shipment Customization")
		shipment:Dock(TOP)
		shipment.DoClick = function(panel)
			nut.gui.supplier:OpenShipment()
		end
		
		--save button
		local saveButton = vgui.Create("DButton", scroll)
		saveButton:SetText("Save")
		saveButton:Dock(TOP)
		saveButton.DoClick = function(panel)
			nut.gui.supplier:SaveSupplier()
			
			self:Close()
		end
	end	
	
	function PANEL:SaveSupplier()
		local data = {}
		for k, v in pairs(self.entries) do
			if(k == "random") then
				data[k] = v:GetChecked()
			else
				data[k] = v:GetText()
			end
		end
		
		data.shipment = self.shipment
	
		netstream.Start("nut_supplierUpdate", self.entity, data)
		
		nut.util.notify("Supplier updated.")
	end
	
	function PANEL:OpenShipment()
		local items = self.shipment
		local lines = {}
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW() * 0.3, ScrH() * 0.3)
		frame:Center()
		frame:SetTitle("")
		frame:MakePopup()
		
		frame.Paint = function(panel, w, h)
			--background image
			surface.SetDrawColor(Color(40, 40, 40, 255))
			surface.DrawRect(0, 0, w, h)
		end
	
		--save button
		local shipmentList = vgui.Create("DListView", frame)
		shipmentList:Dock(FILL)
		--shipmentList:SetTall(frame:GetTall()*0.8)
		shipmentList:AddColumn("Item")
		shipmentList:AddColumn("Amount")
		
		if(table.IsEmpty(items)) then
			items = {
				["food_banana"] = 1,
			}
		end
		
		for k, v in pairs(items) do
			local line = shipmentList:AddLine(k, v)
			line.item = k
			line.amount = v
			line.id = line:GetID()
			
			lines[line.id] = line
			
			--options here, like add a new line or something
			line.OnRightClick = function(panel, lineID)
				-- Just make sure this is defined
				local menu = DermaMenu()
				
				menu:AddOption("Add Line", function()	
					local newLine = shipmentList:AddLine("food_banana", "1")
					newLine.id = newLine:GetID()
					newLine.OnRightClick = panel.OnRightClick
					newLine.item = "food_banana"
					newLine.amount = 1
					
					lines[newLine.id] = newLine
				end):SetImage("icon16/textfield_add.png")
				
				menu:AddOption("Edit Item", function()
					self:EditLine(panel, panel.item, panel.amount)
				end):SetImage("icon16/textfield_add.png")
				
				menu:AddOption("Remove Entry", function()
					lines[panel.id] = nil
					panel:Remove()
				end):SetImage("icon16/textfield_delete.png")
				
				menu:Open()
			end
		end
		
		--save button
		local saveButton = vgui.Create("DButton", frame)
		saveButton:SetText("Save")
		saveButton:Dock(BOTTOM)
		saveButton.DoClick = function(panel)
			local shipment = {}
			
			for k, v in pairs(lines) do
				shipment[v.item] = v.amount
			end
			
			self.shipment = shipment
			
			frame:Close()
		end
	end
	
	function PANEL:EditLine(line, item, amount)
		local frame = vgui.Create("DFrame")
		frame:SetSize(ScrW() * 0.2, ScrH() * 0.2)
		frame:Center()
		frame:SetTitle("")
		frame:MakePopup()
		
		frame.Paint = function(panel, w, h)
			--background image
			surface.SetDrawColor(Color(40, 40, 40, 255))
			surface.DrawRect(0, 0, w, h)
		end

		local itemList = vgui.Create("DComboBox", frame)
		itemList:Dock(TOP)
		
		for k, item in pairs(nut.item.list) do
			local name = (item.getName and item:getName()) or item.name

			itemList:AddChoice(name, item.uniqueID)
			itemList:SetValue(name)
		end
		
		itemList:SetValue(item)
		
		--amount
		local costL = vgui.Create("DLabel", frame)
		costL:SetText("Amount:")
		costL:Dock(TOP)

		local itemAmount = vgui.Create("DTextEntry", frame)
		itemAmount:SetText(amount)
		itemAmount:Dock(TOP)
		
		--save button
		local saveButton = vgui.Create("DButton", frame)
		saveButton:SetText("Save")
		saveButton:Dock(TOP)
		saveButton.DoClick = function(panel)
			local itemName, uniqueID = itemList:GetSelected()
			local amount = tonumber(itemAmount:GetText() or 1)
			
			if(!uniqueID) then
				uniqueID = itemList:GetValue()
			end

			line:SetValue(1, uniqueID)
			line.item = uniqueID
			
			line:SetValue(2, amount)
			line.amount = amount
			
			frame:Close()
		end
	end
vgui.Register("nutSupplier", PANEL, "DFrame")