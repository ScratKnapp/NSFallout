ITEM.name = "Money"
ITEM.desc = " "
ITEM.uniqueID = "money_custom"
ITEM.model = "models/mosi/fallout4/props/junk/bottlecaptin.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Currency"
ITEM.color = Color(70, 120, 70)

ITEM.functions.Collect = {
	name = "Collect",
	icon = "icon16/coins.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()

		local value = item:getData("value", item.value or 0)
		client:notify("You have received " ..nut.currency.get(value).. ".")
		char:giveMoney(value)
		
		client:EmitSound("ui_items_bottlecaps_up_01", 75, math.random(95,105))
	end
}

function ITEM:getName()
	local value = self:getData("value", self.value or 0)
	local name = nut.currency.get(value)
	
	return name
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local value = item:getData("value", item.value or 0)
		draw.SimpleText(value, "DermaDefault", w - 12, h - 14, Color(125,125,125), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	end
end