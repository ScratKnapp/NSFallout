PLUGIN.name = "List Storage"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "Storage of item lists with weight."

local INV_TYPE_ID = "simple"

STORAGE_DEFINITIONS = STORAGE_DEFINITIONS or {}

STORAGE_DEFINITIONS["models/props_junk/wood_crate001a.mdl"] = {
	name = "Wood Crate",
	desc = "A crate made out of wood.",
	invType = INV_TYPE_ID,
	invData = {
		w = 4,
		h = 4
	},
	weight = 15
}
STORAGE_DEFINITIONS["models/props_c17/lockers001a.mdl"] = {
	name = "Locker",
	desc = "A white locker.",
	invType = INV_TYPE_ID,
	invData = {
		w = 4,
		h = 6
	}
	,weight = 30,weight = 30
}
STORAGE_DEFINITIONS["models/props_wasteland/controlroom_storagecloset001a.mdl"] = {
	name = "Metal Closet",
	desc = "A green storage closet.",
	invType = INV_TYPE_ID,
	invData = {
		w = 5,
		h = 7
	}
	,weight = 30
}
STORAGE_DEFINITIONS["models/props_wasteland/controlroom_filecabinet002a.mdl"] = {
	name = "File Cabinet",
	desc = "A metal file cabinet.",
	invType = INV_TYPE_ID,
	invData = {
		w = 3,
		h = 6
	}
	,weight = 10
}
STORAGE_DEFINITIONS["models/props_c17/furniturefridge001a.mdl"] = {
	name = "Refrigerator",
	desc = "A metal box to keep food in",
	invType = INV_TYPE_ID,
	invData = {
		w = 3,
		h = 4
	}
	,weight = 10
}
STORAGE_DEFINITIONS["models/props_wasteland/kitchen_fridge001a.mdl"] = {
	name = "Large Refrigerator",
	desc = "A large metal box to keep even more food in.",
	invType = INV_TYPE_ID,
	invData = {
		w = 4,
		h = 5
	}
	,weight = 20
}
STORAGE_DEFINITIONS["models/props_junk/trashbin01a.mdl"] = {
	name = "Trash Bin",
	desc = "A container for junk.",
	invType = INV_TYPE_ID,
	invData = {
		w = 1,
		h = 3
	}
	,weight = 4
}
STORAGE_DEFINITIONS["models/items/ammocrate_smg1.mdl"] = {
	name = "Ammo Crate",
	desc = "A heavy crate for storing ammunition.",
	invType = INV_TYPE_ID,
	invData = {
		w = 5,
		h = 3
	},
	
	onOpen = function(entity, activator)
		entity:ResetSequence("Close")

		timer.Create("CloseLid"..entity:EntIndex(), 2, 1, function()
			if (IsValid(entity)) then
				entity:ResetSequence("Open")
			end
		end)
	end
	,weight = 6
}
if (CLIENT) then
	function PLUGIN:StorageOpen(storage)
		if (
			IsValid(storage) and
			storage:getStorageInfo().invType == INV_TYPE_ID
		) then
			vgui.Create("nutListStorage"):setStorage(storage)
		end
	end
end
