local PLUGIN = PLUGIN
PLUGIN.name = "Titles"
PLUGIN.author = "Chancer"
PLUGIN.desc = "Fancy titles for your characters."

PLUGIN.titleList = PLUGIN.titleList or {}

nut.command.add("titleselect", {
	syntax = "<string title>",
	onRun = function(client, arguments)
		if(!arguments[1]) then
			client:notify("No title specified.")
			return false
		end

		local titles = client:getNetVar("titles", {})
		
		local id
		for k, v in pairs(titles) do
			if(string.lower(v) == string.lower(arguments[1])) then
				id = k
				break
			elseif(string.find(string.lower(v), string.lower(arguments[1]))) then
				id = k
			end
		end
		
		if(id) then
			PLUGIN:titleSelected(client, id)
			client:notify("You've selected the " ..PLUGIN.titleList[id].name.. " title.")
		end
	end
})

nut.command.add("titleselectadmin", {
	adminOnly = true,
	syntax = "<string target> <string title>",
	onRun = function(client, arguments)
		if(!arguments[2]) then
			client:notify("No title specified.")
			return false
		end

		local target = nut.command.findPlayer(client, arguments[1])
		if(target) then
			local titles = target:getNetVar("titles", {})
		
			local id
			for k, v in pairs(titles) do
				if(string.lower(v) == string.lower(arguments[1])) then
					id = k
					break
				elseif(string.find(string.lower(v), string.lower(arguments[1]))) then
					id = k
				end
			end
			
			if(id) then
				PLUGIN:titleSelected(target, id)
				client:notify("You've selected the " ..PLUGIN.titleList[id].name.. " title for " ..target:Name().. ".")
			else
				client:notify(target:Name().. " does not have that title.")
			end
		end
	end
})

nut.command.add("titleadd", {
	adminOnly = true,
	syntax = "<string target> <string title>",
	onRun = function(client, arguments)
		local titleName = arguments[2]
		if(!titleName) then
			client:notify("No title specified.")
			return false
		end
		
		local target = nut.command.findPlayer(client, arguments[1])
		if(target) then
			local char = target:getChar()
			if(!char) then return end

			local title = PLUGIN:titleFind(titleName)

			if(title) then
				local titlesData = char:getData("titles", {}) --this one is saved to the character, just id numbers
			
				if(!titlesData[title.id]) then
					PLUGIN:addTitle(target, title.id)

					client:notify("You've given the " ..(title.name or " ").. " title to " ..target:Name().. ".")
					target:notify("You've gained the " ..(title.name or " ").. " title.")
				else
					client:notify(target:Name().. " already has the " ..title.name.. " title .")
				end
			else
				client:notify("Title not found.")
			end
		end
	end
})

nut.command.add("titleremove", {
	adminOnly = true,
	syntax = "<string target> <string title>",
	onRun = function(client, arguments)
		local titleName = arguments[2]
		if(!titleName) then
			client:notify("No title specified.")
			return false
		end
		
		local target = nut.command.findPlayer(client, arguments[1])
		if(target) then
			local char = target:getChar()
			if(!char) then return end

			local title = PLUGIN:titleFind(titleName)

			if(title) then
				local titlesData = char:getData("titles", {}) --this one is saved to the character, just id numbers
			
				if(titlesData[title.id]) then
					PLUGIN:removeTitle(target, title.id)

					client:notify("You've taken the " ..title.name.. " title from " ..target:Name().. ".")
					target:notify("You've lost the " ..title.name.. " title.")
				else
					client:notify(target:Name().. " does not have that title.")
				end
			else
				client:notify("Title not found.")
			end
		end
	end
})

nut.command.add("titlecreate", {
	adminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		PLUGIN:titleCreate(client)
	end
})

nut.command.add("titlemenu", {
	adminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		PLUGIN:titleMenuGenerate(client)
	end
})

nut.command.add("titlegeneratetest", {
	adminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		PLUGIN:generatedTitle(client)
	end
})

nut.command.add("dbtitlewipe", {
	superAdminOnly = true,
	syntax = "<none>",
	onRun = function(client, arguments)
		local drop
		
		if (nut.db.object) then
			drop = [[DROP TABLE IF EXISTS `nut_titles`;]]
			nut.db.query(drop, function()
			
			end)
		else
			drop = [[DROP TABLE IF EXISTS nut_titles;]]
			nut.db.query(drop)
		end
	end
})