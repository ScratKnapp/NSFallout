local PLUGIN = PLUGIN

local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.combat)) then
			nut.gui.combat:Remove()
		end
		
		nut.gui.combat = self

		self:SetSize(ScrW() * 0.3, ScrH() * 0.45)
		self:Center()
		--self:SetPos(ScrW() * 0.2, ScrH() * 0.2)
		self:SetTitle("Commands")
		self:MakePopup()
		
		local inner = vgui.Create("DScrollPanel", self)
		inner:Dock(FILL)

		if(nut.plugin.list["combat"]) then
			local guide = inner:Add("DTextEntry")
			guide:Dock(TOP)
			guide:DockMargin(2,2,2,2)
			guide:SetSize(ScrW() * 0.35, ScrH() * 2)
			guide:SetFont("nutSmallFont")
			guide:SetTextColor(Color(255,255,255))
			guide:SetPaintBackground(false)
			guide:SetWrap(true)
			guide:SetMultiline(true)
			
			local guideText = [[
				This system is not 100% static. An admin may choose to use P2L, the combat system, or modify the rules to their discretion.
				
				This guideline will outline the order of combat, what actions you can take, and what counts as an AP in combat.

				When combat begins, every player and every NPC has only two action points (AP) unless otherwise stated.
				Action Points (AP) determine how many actions you or enemies can take per turn. Generally, all actions cost one AP to utilize unless an admin determines otherwise. This includes moving, changing stances, reloading, attacking, and interacting with objects.
  
				Unless an admin allows you to perform an extra action, the only form of additional AP that may be gained, shall be from ability based buffs, such as Hasten.
				
				MOVEMENT:
				Movement is determined by your AP movement circle. Upon your turn beginning, an AP circle will be drawn around you, or you can activate it utilizing the command, /apcircle, to see the distance you are allowed to move.
				The two rings drawn by /apcircle show the amount of distance you can cover with 1 (The closer ring) and 2 AP (the farther ring) respectively.
				When moving, players and NPCs are allowed to attack in the middle of a movement action, provided they have enough AP to do so, and do not have to stop or interrupt their movement action halfway to continue firing.
				Movements during combat and when under fire shall consider the momentum rule: Movements can only be taken in one direction to account for momentum. One may not halt their movement and move directly back into the same point of origin without expending a second movement action.
				Peeking out of cover is considered a movement action, however one can return into full cover within one AP movement.
				Movement can be interrupted at an admin's discretion.
				
				ATTACKING:				
				Attacking is dictated by the combat tool. Though most attacks require line of sight, some can be activated with or without line of sight such as attacks with an area of effect. (Grenades, bombs, traps.)
				The combat tool allows for specific targetting of limbs, however you are only allowed to target limbs that you have direct line of sight to, and must determine what you can and cannot target based on roleplay, as well as the part of the entity you can see.
				This applies to targets that may not have the specific limbs that can be targetted via the system. (Such as a robot that has no legs, cannot be targetted in the 'legs'.)
				When attacking, you are not required to fire an OOC round to simulate the expenditure of said round. As the tool calculates ammunition count and reloading as an action point usage.
				Equipment such as grenades, mines, and throwing weapons do not require any AP to draw, however individual attacks each cost one AP to utilize.
 
				If you go from non-combative posture, to a combative posture, that is one AP. IE, drawing from a holster, or having your rifle low is considered non-combat, and raising it to target is considered drawing a weapon, and costs an AP.
				Swapping between weapons is considered an AP. Drawing and firing is two AP.

				Item usage in combat requires one AP: Medical, Food, Drugs, etc.
				
				The Combat tool provides a number of actions a player may take, including fire modes, special moves, and charisma abilities. These actions are to be utilized with the combat tool so long as the combat tool is in play by the admin, however an admin may elect to disregard aspects of the combat tool at their own will.
				This means an admin may modify any of the rules, and may choose to avoid, modify, or disregard any of the rules using the combat tool to what they feel is better for the flow of combat, and for narrative purposes.
				
				Speaking or relaying information shall not be considered AP usage, unless a player is excessively talking or coordinating other players actions. If done out of turn, an admin may punish a player for doing so.

 
				INITIATING COMBAT:
				Often left to admin discretion, but there are circumstances that dictate turn order:
 
				For players to decide who goes first, with no admin supervision, the attacker will go first. 
				If there is no clear-cut attacker, and it is a ‘mutual’ combat, both parties shall roll /agility to determine turn order. 
				
				When players engage in combat with one another, the scenario will initiate based on the highest agility roll, followed by the next highest roll, and so on.
				However, when the number of players on is three or more, any allied players shall be considered under one roll as a team, and will share the same turn order.
				These can be interrupted or changed based on an admin's discretion.

				COVER AND OVERWATCH:

				Cover is not calculated by the combat tool, but determines what an individual can, or cannot target. As line of sight is required to attack, an individual must be completely out of line of sight to be considered in cover.
				While behind cover, movements that would move you out of cover even for a brief moment will still cost an AP 
				Behind cover, every movement you conduct that would bring you out of cover is considered an action, and will cost one AP point, however you are allowed to exit/peek out of cover to attack, and then return to cover without expending more than one AP.
				ie: Ducking, Rising, Peaking.
				
				Overwatch can be taken during ones turn. This requires spending an AP to engage overwatch. Once overwatch is taken, a player or NPC is allowed to fire on any target that moves into line of sight on their turn. Overwatch can only fire a normal attack.


				STATS 
				
				STRENGTH - Affects weapon strength requirements, melee damage, and provides +1 HP per strength point.
				PERCEPTION - Affects energy weapon damage, accuracy.
				ENDURANCE - Affects natural damage resistance, provides +2 HP per endurance point.
				CHARISMA - Affects charisma abilities, chance modifiers, speech skill.
				INTELLIGENCE - Affects healing ability scaling, intelligence non-combat skill modifier.
				AGILITY - Affects evasion chance, athletics modifier.
				LUCK - Affects crit chance, and affects all skills slightly on character creation.
							
				STUNS AND GRAPPLES:
				Most normal NPCS will have standard rules for grappling and stuns, however enemies meant to be bosses will be treated as having an increasing resistance to stuns. 
				This depends from enemy to enemy and admin interpretation, for example large bosses may not be stunned or grappled whatosever, some human bosses may be grappled or stunned, and some may have a form of staleness - where the first stun may be effective, the next only reduce AP, or so on. An admin may also have an NPC/boss break out of a grapple without utilizing the swep if necessary for the flow of combat. Admins are responsible for letting this mechanic be known in or before the encounter.
				
				
				ADDITIONAL:
 
				Rechambering a weapon is not allowed.
			]]
			
			guide.AllowInput = function()
				return true
			end
			guide:SetEnabled(false)
			guide:SetText(guideText)
		end
	end
vgui.Register("nutCombat", PANEL, "DFrame")

timer.Simple(1, function()
	nut.plugin.list["minimenu"]:addMenu({"Combat Guide", "nutCombat"})
end)