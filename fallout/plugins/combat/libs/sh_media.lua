local PLUGIN = PLUGIN

if(SERVER) then
	function PLUGIN:MediaPlay(target, url)
		local opts = {
			meta = {
				title = "Music (F8)"
			},
			onError = function(err)
				--ply:ChatPrint(err)
			end
		}

		wmcp.PlayFor(target, url, opts)
	end

	function PLUGIN:MediaStop(target)
		wmcp.StopFor(target)
	end
	
	netstream.Hook("turn_mediaPlay", function(client, targets, url)
		if(!client:IsAdmin()) then return false end
	
		for k, target in pairs(targets) do
			PLUGIN:MediaPlay(target, url)
		end
	end)
	
	netstream.Hook("turn_mediaStop", function(client, targets)
		if(!client:IsAdmin()) then return false end
	
		for k, target in pairs(targets) do
			PLUGIN:MediaStop(target)
		end
	end)
end