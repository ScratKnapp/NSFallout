local PLUGIN = PLUGIN
PLUGIN.name = "Money Items"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Lets you drop money as an item."

nut.command.add("moneyconvert", {
	syntax = "<number money>",
	onRun = function(client, arguments)
		local money = client:getChar():getMoney()
	
		local drop = tonumber(arguments[1])
		if(!drop) then
			client:notify("Specify a money amount.")
			return false
		end
		
		drop = math.Round(drop)
		
		if(drop < 1) then
			client:notify("You cannot do that.")
			return false
		end
		
		if(money < drop) then
			client:notify("You do not have enough money.")
			return false
		end
		
		local char = client:getChar()
		local inventory = char:getInv()
		
		char:takeMoney(drop)
		
		local data = {}
		data.value = drop
		
		inventory:addSmart("money_custom", 1, position, data)
		
		client:notify("You have converted " ..nut.currency.get(drop).. " into an item.")
	
		client:EmitSound("ui_items_bottlecaps_down_01", 75, math.random(95,105))
	end
})

nut.command.add("spawnmoney", {
	adminOnly = true,
	syntax = "<number money>",
	onRun = function(client, arguments)
		local money = client:getChar():getMoney()
	
		local drop = tonumber(arguments[1])
		if(!drop) then
			client:notify("Specify a money amount.")
			return false
		end
		
		drop = math.Round(drop)
		
		if(drop < 1) then
			client:notify("You cannot do that.")
			return false
		end
		
		local char = client:getChar()
		local inventory = char:getInv()
		
		local data = {}
		data.value = drop
		
		local aimPos = client:GetEyeTraceNoCursor().HitPos 
        aimPos:Add(Vector(0, 0, 10))
			
		nut.item.spawn("money_custom", aimPos, function(item)
			item:setData("value", drop)
		end)
		
		client:notify("You have spawned " ..nut.currency.get(drop).. ".")
	end
})

nut.command.add("dropmoney", {
	syntax = "<number amount>",
	onRun = function(client, arguments)
		local amount = tonumber(arguments[1])

		if (!amount or !isnumber(amount) or amount < 1) then
			return "@invalidArg", 1
		end

		amount = math.Round(amount)
		
		if (!client:getChar():hasMoney(amount)) then
			return
		end

		client:getChar():takeMoney(amount)
		local money = nut.currency.spawn(client:getItemDropPos(), amount)
		money.client = client
		money.charID = client:getChar():getID()
		
		client:doGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
	
		client:EmitSound("ui_items_bottlecaps_down_01.wav", 75, math.random(95,105))
	end
})