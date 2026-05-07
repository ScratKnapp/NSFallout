local PLUGIN = PLUGIN

--name adjective, desc
PLUGIN.lootAdj = {
	{
		name = "Exquisite",
		desc = "This piece of equipment is an artwork in its own form. Its beauty unmatched, and was clearly created by a skilled artisan.",

		rarity = 5,
		level = 15,

		dmgMult = 1.1,
		armMult = 1.1,
	},	
	{
		name = "Heirloom",
		desc = "Its craftsmanship and valuable decorations alongside some inscriptions indicate that this is the heirloom that belonged to another family.",

		rarity = 8,
		level = 1,

		armMult = 1.2,
		dmgMult = 1.2,
		weightMult = 1.05,
	},
	{ 
		name = "Gaudy", 
		desc = "It's extravagantly bright and showy, tasteless even.",
		
		rarity = 5,
		level = 1,
	},	
	{ 
		name = "Ordinary", 
		desc = "It's so incredibly ordinary that it somehow stands out.",
		
		rarity = 35,
		level = 1,
	},
	{
		name = "Reliable",
		desc = "Its craftsmanship renders it this piece of equipment to be of consistent quality and enough to be depended on.",

		rarity = 25,
		level = 1,

		armMult = 1.1,
		dmgMult = 1.1,
		weightMult = 1.05,
	},
	{
		name = "Trusty",
		desc = "Judging by the condition of this weapon, its consistent quality seems to have lasted its previous user quite well.",

		rarity = 25,
		level = 1,

		armMult = 1.1,
		dmgMult = 1.1,

		restrict = {
			slot = {
				["Weapon"] = true,
			}
		}
	},
	{
		name = "Wieldy",
		desc = "The craftsmanship of this weapon lets it be able to be handled and utilized rather easily.",

		rarity = 25,
		level = 1,

		dmgMult = 1.05,

		restrict = {
			slot = {
				["Weapon"] = true,
			}
		}
	},	
	{
		name = "Sluggish",
		desc = "The craftsmanship of this piece of equipment was subpar, and has resulted in more unnecessary weight in unhelpful places, making it heavier than it should.",

		rarity = 35,
		level = 1,

		armorMult = 1.05,
		dmgMult = 1.05,
		weightMult = 1.35,
	},	
	{ 
		name = "Frail", --name of the item
		desc = "This was made from sub-optimal material, so it doesn't seem to be able to withstand much force.",

		rarity = 35,
		level = 1,

		armMult = 0.9,
		dmgMult = 0.8,
		weightMult = 0.8,
	},	
	{ 
		name = "Flimsy",
		desc = "This has either suffered extensive damage, or its original creator simply wasn't very good at what they were doing.",

		rarity = 35,
		level = 1,

		armMult = 0.9,
		dmgMult = 0.8,
		weightMult = 0.9,
	},
	{ 
		name = "Bloody", 
		desc = "It is stained with blood.",
		
		rarity = 20,
		level = 5,
		
		attrib = {
			["stm"] = {1, 4},
			["end"] = {-2, 0},
		},
	},
	{ 
		name = "Unsettling", 
		desc = "It is decorated with strange shapes and unworldly creatures.",
		
		rarity = 10,
		level = 5,
		
		attrib = {
			["mana"] = {-2, 4},
			["intelligence"] = {-1, 4},
		},
	},
	{ 
		name = "Light", 
		desc = "Its craftsmanship renders it lighter than it normally would be.",
		
		rarity = 30,
		level = 1,
		
		armMult = 0.95,
		dmgMult = 0.95,
		weightMult = 0.9,
	},
	{ 
		name = "Heavy", 
		desc = "Its craftsmanship renders it heavier than it normally would be.",
		
		rarity = 30,
		level = 1,
		
		armMult = 1.05,
		dmgMult = 1.05,
		weightMult = 1.1,
	},	
	{
		name = "Bulky",
		desc = "Its craftsmanship or material renders it much heavier than it normally would be.",

		rarity = 30,
		level = 1,

		armMult = 1.15,
		dmgMult = 1.15,
		weightMult = 1.35,
	},
	{ 
		name = "Hardened", 
		desc = "The material comprising this armor is strangely harder than normal.",
		
		rarity = 10,
		level = 1,
		
		armMult = 1.1,
		weightMult = 1.2,
		
		restrict = {
			slot = {
				["Torso"] = true,
			}
		}		
	},
	{ 
		name = "Old", 
		desc = "This equipment is clearly old and has seen a fair share of use.",
		
		rarity = 25,
		level = 1,
		
		armMult = 0.9,
		dmgMult = 0.9,
		weightMult = 0.9,
		
		attrib = {
			["luck"] = {1, 3},
		},		
	},	
	{ 
		name = "Shoddy", 
		desc = "This equipment is not properly crafted or designed.",
		
		rarity = 25,
		level = 1,
		
		armMult = 0.8,
		dmgMult = 0.8,
		weightMult = 1.05,
		
		attrib = {
			["stm"] = {-2, 1},
			["intelligence"] = {-2, 0},
		},
	},
	{ 
		name = "Damaged", 
		desc = "This equipment is damaged and has seen better days.",
		
		rarity = 30,
		level = 1,
		
		armMult = 0.5,
		dmgMult = 0.5,
		weightMult = 0.9,
		
		attrib = {
			["end"] = {-5, 1},
			["intelligence"] = {-5, 1},
		},
	},	
	{
		name = "Rusty",
		desc = "This piece of equipment appears to have been in long disrepair, and is covered in rust.",

		rarity = 30,
		level = 1,

		armMult = 0.6,
		dmgMult = 0.6,
		weightMult = 1.1,
	},
	{
		name = "Bent",
		desc = "This weapon seems to have received some damage and was bent as a result.",

		rarity = 20,
		level = 5,

		dmgMult = 0.6,

		restrict = {
			slot = {
				["Weapon"] = true,
			}
		}
	},	
	{ 
		name = "Repaired", 
		desc = "This equipment has obvious signs of maintenance and care, which gives it its own kind of charm.",
		
		rarity = 20,
		level = 1,
		
		armMult = 1.025,
		dmgMult = 1.025,
		weightMult = 1.05,
		
		attrib = {
			["stm"] = {-1, 1},
			["talent"] = {-1, 3},
		},
	},
	{ 
		name = "Lucky", 
		desc = "This equipment has a certain charm to it, it feels lucky to you.",
		
		rarity = 15,
		level = 1,	
	},
	{
		name = "Razor-edged", 
		desc = "Its craftsmanship renders it lighter than it normally would be.",
		
		rarity = 20,
		level = 5,
		
		dmgMult = 1.05,
		
		restrict = {
			dmgT = {
				["Slash"] = true,
			},
			slot = {
				["Weapon"] = true,
			}
		}
	},
	{
		name = "Blunted", 
		desc = "Through excessive use the blade has become blunt.",
		
		rarity = 20,
		level = 5,
		
		dmgMult = 0.9,
		dmgT = "Crush",
		
		restrict = {
			dmgT = {
				["Slash"] = true,
			},
			slot = {
				["Weapon"] = true,
			}
		}
	},
	{
		name = "Golden", 
		desc = "This object is made out of gold, and is mostly decorative. May be valuable to a collector or a merchant.",
		
		rarity = 3,
		level = 1,
		
		dmgMult = 0.5,
		weightMult = 2,
	},
}
