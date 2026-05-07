ITEM.name = "Caps (2)"
ITEM.desc = "A pair of caps in a small tin."
ITEM.uniqueID = "coin_5"
ITEM.model = "models/mosi/fallout4/props/junk/bottlecaptin.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.flag = "v"
ITEM.price = 5
ITEM.category = "Currency"
ITEM.color = Color(70, 120, 70)

ITEM.value = 5

ITEM.functions.Collect = {
	name = "Collect",
	icon = "icon16/coins.png",
	sound = "ambient/materials/cupdrop.wav",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()

		local value = item.value

		client:notify("You have received " ..nut.currency.get(value).. ".")
		char:giveMoney(item.value)
		
		client:EmitSound("ui_items_bottlecaps_up_01", 75, math.random(95,105))
	end
}

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		draw.SimpleText(item.value, "DermaDefault", w - 12, h - 14, Color(125,125,125), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	end
end