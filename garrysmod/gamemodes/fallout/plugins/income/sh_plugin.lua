local PLUGIN = PLUGIN
PLUGIN.name = "Income"
PLUGIN.author = "Chancer"
PLUGIN.desc = "An income system that works on a per character basis."

nut.command.add("income", {
	onRun = function(client, arguments)
		local char = client:getChar()
		
		local income = char:getData("income", {})
		
		if((income[1] or 0) > 0) then
			local lastInc = char:getData("lastInc")
			
			if(!lastInc) then
				char:setData("lastInc", 0)
				lastInc = 900 --big number just ignore it
			end
			
			local cooldown = income[2]
			
			local daysSince = math.abs(tonumber(lastInc) - tonumber(os.date("%d")))
			
			if(daysSince >= cooldown) then -- collect once every X days
				char:setData("lastInc", tonumber(os.date("%d")))
				char:giveMoney(income[1])
				client:notify("You have received " ..nut.currency.get(income[1]).. ".")
			else
				client:notify("You cannot collect income for " ..(cooldown - daysSince).. " days.")
			end
		else
			client:notify("You do not have any income.")
		end
	end
})

nut.command.add("charsetincome", {
	adminOnly = true,
	syntax = "<string name> <number income> <number days>",
	onRun = function(client, arguments)
		local income = tonumber(arguments[2] and arguments[2] or "")
		local days = tonumber(arguments[3] and arguments[3] or "")
	
		if(!income) then
			client:notify("Specify an income amount.")
			return false
		end
		
		if(!days) then
			client:notify("Specify a days amount.")
			return false
		end
	
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			target:getChar():setData("income", {income, days})
			client:notify("You have set " ..target:Name().. "'s income to " ..nut.currency.get(income).. " every " ..days.. " days.")
		end
	end
})

nut.command.add("chargetincome", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if(IsValid(target) and target:getChar()) then
			local income = target:getChar():getData("income")
			if(!income) then
				client:notify(target:Name().. " has no income.")
				return false
			else
				local money = income[1]
				local days = income[2]
				client:notify(target:Name().. " may receive " ..nut.currency.get(money).. " every " ..days.. " days.")
			end
		end
	end
})