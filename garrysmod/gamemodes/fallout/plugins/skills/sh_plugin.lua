PLUGIN.name = "Fallout Skills"
PLUGIN.author = " "
PLUGIN.desc = "Adds fallout skills for characters."

nut.util.include("sh_commands.lua")

nut.config.add(
	"maxSkills",
	20,
	"The total maximum amount of skill points allowed.",
	nil,
	{
		data = {min = 1, max = 250},
		category = "characters"
	}
)

nut.config.add(
	"charCreateSkills",
	25,
	"The amount of skill points given in character creation.",
	nil,
	{
		data = {min = 1, max = 250},
		category = "characters"
	}
)

nut.char.registerVar("skills", {
	field = "_skills",
	default = {},
	isLocal = true,
	--index = 4,
	onValidate = function(value, data, client)
		if (value != nil) then
			if (type(value) == "table") then
				local count = 0

				for k, v in pairs(value) do
					count = count + v
				end

				local points = hook.Run("GetStartSkillPoints", client, count)
					or nut.config.get("charCreateSkills", 25)
				if (count > points) then
					return false, "unknownError"
				end
			else
				return false, "unknownError"
			end
		end
	end,
	shouldDisplay = function(panel) return table.Count(nut.skills.list) > 0 end
})

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
		nut.skills.setup(client)
	end

	function PLUGIN:OnCharSkillBoosted(client, character, skillID)
		local skill = nut.skills.list[skillID]
		if (skill and isfunction(skill.onSetup)) then
			skill:onSetup(client, character:getSkill(skillID, 0))
		end
	end
else
	function PLUGIN:ConfigureCharacterCreationSteps(panel)
		panel:addStep(vgui.Create("nutCharacterSkills"), 4)
	end
end

function PLUGIN:getSpecialSkillBonus(attribs)
	local specialSkills = {}
	
	for attribID, attribAmt in pairs(attribs) do
		local attrib = nut.attribs.list[attribID]
		if(attrib) then
			local skillBonus = attrib.skillBonus and attrib.skillBonus[k]
			if(skillBonus) then
				specialSkills[k] = skillBonus*attribAmt
			end
		end
	end
	
	return specialSkills
end

nut.chat.register("skillcheck", {
	format = "%s %s.",
	color = PLUGIN.CHATCOLOR_REACT,
	filter = "actions",
	font = COMBAT_FONT,
	onCanHear = nut.config.get("chatRange", 280) * 4,
	deadCanChat = true
})
