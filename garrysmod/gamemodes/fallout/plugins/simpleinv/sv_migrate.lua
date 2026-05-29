-- Server-console command to retype every existing inventory to the list
-- ("simple") inventory. Run once after switching the player/storage inventory
-- from grid to list: old rows still carry _invType = "grid" (or another
-- now-unregistered type) and won't load until they're retyped.

local INV_TABLE = "inventories"
local TARGET_TYPE = "simple"
-- Everything that isn't already the list type: old "grid" rows, legacy
-- bag/storage types, and NULL rows written before a type existed.
local FILTER = "_invType != '"..TARGET_TYPE.."' OR _invType IS NULL"
local COLOR = Color(255, 0, 255)

local function log(message)
	MsgC(COLOR, "[LIST INV MIGRATION] "..message.."\n")
end

local function migrate()
	-- Block periodic/character saves so any loaded instance can't write its
	-- stale type back over the rows we're about to change.
	nut.shuttingDown = true
	log("Scanning inventories...")

	nut.db.select({"_invID"}, INV_TABLE, FILTER)
		:next(function(res)
			local count = #(res.results or {})
			if (count == 0) then
				nut.shuttingDown = false
				log("Every inventory is already the list type. Nothing to do.")
				return
			end

			local d = deferred.new()
			nut.db.updateTable(
				{_invType = TARGET_TYPE},
				function() d:resolve(count) end,
				INV_TABLE,
				FILTER
			)
			return d
		end)
		:next(function(migrated)
			if (not migrated) then return end

			-- Stop the upcoming map change from saving stale in-memory state
			-- over the migrated rows.
			hook.Add("ShouldDataBeSaved", "nwlListInvMigration", function()
				return false
			end)

			log("Migrated "..migrated.." inventories to the list type.")
			log("Reloading the map to load them fresh...")
			RunConsoleCommand("changelevel", game.GetMap())
		end)
end

concommand.Add("nwl_migrate_inv_to_list", function(client)
	-- Server console only: client is NULL from the host/RCON console.
	if (IsValid(client)) then return end
	migrate()
end)
