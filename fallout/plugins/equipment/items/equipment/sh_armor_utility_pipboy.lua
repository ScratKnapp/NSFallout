ITEM.name = "Pip-Boy 3000"
ITEM.desc = "A pre-war electronic Personal Information Processor serving as a wearer's personal information and inventory database."
ITEM.model = "models/llama/pipboy3000.mdl"
ITEM.height = 1
ITEM.width = 1
ITEM.price = 5000
ITEM.armor = 1 --DT based armor
ITEM.durability = 250

ITEM.res = { --percentage based armor
  ["Damage"] = 0,
  ["Energy"] = 0, 
}
ITEM.specialSlot = "Utility"
ITEM.attrib = { --gives the player stats on equip

}

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	onRun = function(item)
		item:setData("power", !item:getData("power", false), player.GetAll(), false, true)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end
}

ITEM.functions.freq = { -- sorry, for name order.
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	onRun = function(item)
		netstream.Start(item.player, "radioAdjust", item:getData("freq", "000,0"), item.id)

		return false
	end
}

if(CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(4, 4, 8, 8)
		
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end