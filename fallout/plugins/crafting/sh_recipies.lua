local PLUGIN = PLUGIN

local RECIPE

--professions
--[[
	"science"
	"chef"
	"blacksmith"
	"armorsmith"
	"gunsmith"
	"ammosmith"
--]]

--COOKING
//
RECIPE = {}
RECIPE.uid = "cook_meal"
RECIPE.name = "Meal"
RECIPE.category = "Cooking (Free Craft)"
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.desc = "A meal."
RECIPE.profession = "cook"
RECIPE.level = 0
RECIPE.xp = 0.01
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Ingredient"] = 3,
}
RECIPE.result = {
	["meal"] = 1
}
RECIPES:Register(RECIPE)
//

--DRUGS
//
RECIPE = {}
RECIPE.uid = "drug_1"
RECIPE.name = "Drug (Tier-1)"
RECIPE.category = "Drugs (Free Craft)"
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.desc = "Some kind of drug."
RECIPE.profession = "drug"
RECIPE.tblLevel = 1
RECIPE.xp = 0.01
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Raw Alcohol"] = 1,
	["Drug"] = 3,
}
RECIPE.result = {
	["drug"] = 1
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "drug_2"
RECIPE.name = "Drug (Tier-2)"
RECIPE.category = "Drugs (Free Craft)"
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.desc = "Some kind of drug."
RECIPE.profession = "drug"
RECIPE.tblLevel = 2
RECIPE.xp = 0.01
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Filler"] = 1,
	["Drug"] = 6,
}
RECIPE.result = {
	["drug"] = 1
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "drug_3"
RECIPE.name = "Drug (Tier-3)"
RECIPE.category = "Drugs (Free Craft)"
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.desc = "Some kind of drug."
RECIPE.profession = "drug"
RECIPE.tblLevel = 3
RECIPE.xp = 0.01
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Beta2"] = 1,
	["Drug"] = 9,
}
RECIPE.result = {
	["drug"] = 1
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "recipeuniqueid"
RECIPE.name = "Name in Crafting Menu"
RECIPE.category = "Category in Crafting menu"
RECIPE.model = "modelpath"
RECIPE.desc = "description"
RECIPE.profession = "trait here"
RECIPE.items = {
	--uniqueID, if unspecified in the file, are the file name without the sh_
	["item uniqueID"] = 1, 
	["item uniqueID2"] = 12,
}
RECIPE.result = {
	["item uniqueID3"] = 1
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "drug_5"
RECIPE.name = "Drug (Tier-5)"
RECIPE.category = "Drugs (Free Craft)"
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.desc = "Some kind of drug."
RECIPE.profession = "drug"
RECIPE.tblLevel = 5
RECIPE.xp = 0.01
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Injector"] = 1,
	["Drug"] = 15,
}
RECIPE.result = {
	["drug"] = 1
}
RECIPES:Register(RECIPE)


//
RECIPE = {}
RECIPE.uid = "tailor_shirt"
RECIPE.name = "Shirt"
RECIPE.category = "Tailoring (Free Craft)"
RECIPE.model = "models/props_junk/cardboard_box004a.mdl"
RECIPE.desc = "A shirt."
RECIPE.profession = "tailor"
RECIPE.level = 0
RECIPE.special = true
RECIPE.noAverage = true
RECIPE.items = {
	["Clothing Material"] = 2,
}
RECIPE.result = {
	["shirt"] = 1
}
RECIPES:Register(RECIPE)
//


---------------------------------------------------------------------- non-dynamic crafting

--COOKING

RECIPE = {}
RECIPE.uid = "atomiccocktail"
RECIPE.name = "Atomic Cocktail"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fnv/props/drink/alcohol/atomiccocktail.mdl"
RECIPE.desc = "A novelty drink mixer shaped like a rocket ship, filled with equal parts vodka and Nuka-Cola, and ground mentats."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_nukacola"] = 1, 
    ["alc_vodka"] = 1,
	["drug_mentats"] = 1,

}
RECIPE.result = {
    ["alc_atomiccocktail"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "cowboycoffee"
RECIPE.name = "Cowboy Coffee"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fnv/props/drink/antnog.mdl"
RECIPE.desc = "Boiled honey mesquite pods, mixed with a healthy kick of whiskey."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_honeymesquite"] = 1, 
    ["food_purifiedwater"] = 1,
	["alc_whiskey"] = 1,

}
RECIPE.result = {
    ["drink_cowboycoffee"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "dirtywastelander"
RECIPE.name = "Dirty Wastelander"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fallout4/props/alcohol/warebrew.mdl"
RECIPE.desc = "An east coast cocktail with a tart and sweet taste."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_nukacola"] = 1, 
    ["food_purifiedwater"] = 1,
	["alc_vodka"] = 1,
	["food_tarberry"] = 1,

}
RECIPE.result = {
    ["drink_dirtywastelander"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "cactuswater"
RECIPE.name = "Cactus Water"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fnv/props/drink/water_dirty.mdl"
RECIPE.desc = "Cut and boiled prickly pear juice."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_pricklypear"] = 3, 
    ["food_purifiedwater"] = 1,

}
RECIPE.result = {
    ["drink_cactuswater"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "homebrewcola"
RECIPE.name = "Homebrew Cola"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fnv/props/drink/nukacola_quartz.mdl"
RECIPE.desc = "A poor post-war imitation of the popular fizzy drink, Nuka Cola."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_sugar"] = 3, 
    ["food_purifiedwater"] = 1,
    ["food_agavefruit"] = 1,
    ["food_barrelcactus"] = 1,

}
RECIPE.result = {
    ["drink_homebrewcola"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "homebrewsarsa"
RECIPE.name = "Homebrew Sarsaparilla"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fnv/props/drink/sunsetsasparilla.mdl"
RECIPE.desc = "A poor imitation of the most popular sarsaparilla."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_sugar"] = 3, 
    ["food_purifiedwater"] = 1,
    ["food_agavefruit"] = 1,
    ["food_xanderroot"] = 1,

}
RECIPE.result = {
    ["drink_homebrewsarsa"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "wastertequila"
RECIPE.name = "Wasteland Tequila"
RECIPE.category = "Drinks"
RECIPE.model = "models/mosi/fallout4/props/alcohol/warebrew.mdl"
RECIPE.desc = "Home brewed tequila made from local agave plants."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_purifiedwater"] = 1,
    ["food_agavefruit"] = 3,

}
RECIPE.result = {
    ["drink_wastertequila"] = 1
}
RECIPES:Register(RECIPE)

//






----------------------------------------------------------------------- COOKING: FOOD





//

RECIPE = {}
RECIPE.uid = "dryloaf"
RECIPE.name = "Dry Loaf"
RECIPE.category = "Food"
RECIPE.model = "models/foodnhouseholditems/bread-4.mdl"
RECIPE.desc = "A dry, tough loaf of bread made with razorgrain."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_flour"] = 3,
    ["food_salt"] = 1,
	["food_geckoegg"] = 1,


}
RECIPE.result = {
    ["food_bread"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "bighornsteak"
RECIPE.name = "Bighorner Steak"
RECIPE.category = "Food"
RECIPE.model = "models/fnv/clutter/food/steak01.mdl"
RECIPE.desc = "A cut of prime Bighorner, grilled to medium well."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_bighorner"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_bighornsteak"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "brahmincheese"
RECIPE.name = "Brahmin Cheese"
RECIPE.category = "Food"
RECIPE.model = "models/foodnhouseholditems/cheesewheel2c.mdl"
RECIPE.desc = "Salted and curdled Brahmin milk."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_milk"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_cheese"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "bakedbloatfly"
RECIPE.name = "Baked Bloatfly"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/bloatflymeat.mdl"
RECIPE.desc = "A cut of bloatfly roasted nearly to the point of burning to clean it."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_bloatflymeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_bakedbloatfly"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "ribeyesteak"
RECIPE.name = "Brahmin Strip Steak"
RECIPE.category = "Food"
RECIPE.model = "models/fnv/clutter/food/steak01.mdl"
RECIPE.desc = "A cut of prime Brahmin, grilled to medium well."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_brahmin"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_brahminsteak"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "muttchops"
RECIPE.name = "Mutt Chops"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/dogmeat.mdl"
RECIPE.desc = "A roasted mongrel thigh."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_dogmeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_muttchops"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "geckokebab"
RECIPE.name = "Gecko Kebab"
RECIPE.category = "Food"
RECIPE.model = "models/fnv/clutter/food/iguanabits.mdl"
RECIPE.desc = "Chunks of grilled gecko, stuck onto a skewer and salted for flavor."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_geckomeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_geckokebab"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "moleratchunks"
RECIPE.name = "Mole Rat Chunks"
RECIPE.category = "Food"
RECIPE.model = "models/foodnhouseholditems/meat6.mdl"
RECIPE.desc = "Several cuts of mole rat meat, lightly fried."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_moleratmeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_moleratchunks"] = 1
}
RECIPES:Register(RECIPE)

//


RECIPE = {}
RECIPE.uid = "noodles"
RECIPE.name = "Dried Noodles"
RECIPE.category = "Food"
RECIPE.model = "models/fnv/clutter/food/ramen01.mdl"
RECIPE.desc = "A bundle of dried noodles for later use. Can be eaten raw if necessary."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_purifiedwater"] = 1,
    ["food_razorgrain"] = 1,

}
RECIPE.result = {
    ["food_noodles"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "radroachsteak"
RECIPE.name = "Radroach Roast"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/radroachmeat.mdl"
RECIPE.desc = "A cut of radroach, roasted to near burning to make it palatable."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_radroachmeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_radroach"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "roastmirelurk"
RECIPE.name = "Mirelurk Cake"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/fnv/clutter/food/mirelurkcake01.mdl"
RECIPE.desc = "A patty of ground mirelurk meat and an egg that's been fried."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_mirelurkmeat"] = 1,
    ["food_salt"] = 2,
	["food_geckoegg"] = 1,


}
RECIPE.result = {
    ["food_mirelurkcake"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "radscorpsteak"
RECIPE.name = "Roasted Radscorpion"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fallout4/props/food/radscorpionsteak.mdl"
RECIPE.desc = "A roasted chunk of oily scorpion meat."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_radscorpionmeat"] = 1,
    ["food_salt"] = 1,

}
RECIPE.result = {
    ["food_radscorpsteak"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "deathclawwellington"
RECIPE.name = "Deathclaw Wellington"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/foodnhouseholditems/bread-2.mdl"
RECIPE.desc = "A filet of Deathclaw encased in a layer of ground and pasted, salted pinyon nuts, and a second layer of bread around it. Considered a luxury meal."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_flour"] = 1,
    ["food_salt"] = 1,
	["food_geckoegg"] = 1,
	["food_deathclawmeat"] = 1,
	["food_pinyonnuts"] = 1,
	

}
RECIPE.result = {
    ["food_deathclawwellington"] = 1
}
RECIPES:Register(RECIPE)

//


RECIPE = {}
RECIPE.uid = "caravanlunch"
RECIPE.name = "Caravan Lunch"
RECIPE.category = "Food"
RECIPE.model = "models/mosi/fnv/props/food/lunchbox_meal.mdl"
RECIPE.desc = "A lunchbox packed full of pre-war foods, used as a cheap and easy caravan ration."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_cram"] = 1,
    ["food_instamash"] = 1,
	["food_porknbeans"] = 1,

}
RECIPE.result = {
    ["food_caravanlunch"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "moleratstew"
RECIPE.name = "Mole Rat Stew"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/fnv/clutter/food/ratstew01.mdl"
RECIPE.desc = "A stew made of mole rat meat and vegetables, simple and seasoned enough to mask the pungent taste of mole rat."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_tato"] = 1,
    ["food_moleratmeat"] = 1,
	["food_purifiedwater"] = 1,
	["food_salt"] = 1,

}
RECIPE.result = {
    ["food_moleratstew"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "scorpionomelet"
RECIPE.name = "Scorpion Omelet"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/mosi/fnv/props/food/wastelandomelette.mdl"
RECIPE.desc = "Fried scorpion eggs, topped with salt."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_radscorpioneggs"] = 2,
    ["food_salt"] = 2,

}
RECIPE.result = {
    ["food_radscorpomelet"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "wastelandslam"
RECIPE.name = "Wasteland Slam"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/foodnhouseholditems/pancake.mdl"
RECIPE.desc = "A hearty breakfast, fit for any chosen sole wandering courier, with two fried deathclaw eggs, a set of bighorner bacon and a cut of Brahmin ribeye with some pickled peppers to the side."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_brahmin"] = 1,
    ["food_bighorner"] = 1,
	["food_jalapeno"] = 2,
	["food_deathclawegg"] = 2,
	["food_salt"] = 1,

}
RECIPE.result = {
    ["food_wastelandslam"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "radramen"
RECIPE.name = "Radramen"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/fnv/clutter/food/ramen01.mdl"
RECIPE.desc = "A bowl of boiled noodles with slices of Brahmin meat, shredded and softened xander root, and salted cuts of cave fungus. For the most discerning of tastes, and popular on the west coast."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_brahmin"] = 1,
    ["food_noodles"] = 1,
	["food_cavefungus"] = 1,
	["food_xanderroot"] = 1,
	["food_purifiedwater"] = 1,
	["food_salt"] = 1,

}
RECIPE.result = {
    ["food_radramen"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "atomburger"
RECIPE.name = "Atom Bomb Burger"
RECIPE.category = "Food - Advanced"
RECIPE.model = "models/foodnhouseholditems/burgergtasa.mdl"
RECIPE.desc = "The glory of American culinary advancements, reborn.\nA loaf of toasted bread, with a large prime deathclaw patty, covered in a thin melted Brahmin cheese, a fried deathclaw egg, one slice of tato, and slices of jalapeno pepper on top.\nOften paired with Nuka-Cola, for the taste of pre-war greatness."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_bread"] = 1,
    ["food_deathclawmeat"] = 1,
	["food_cheese"] = 1,
	["food_tato"] = 1,
	["food_jalapeno"] = 1,
	
}
RECIPE.result = {
    ["food_burger"] = 1
}
RECIPES:Register(RECIPE)

//















































------------------------------------------------------------------
-- gunsmith: guns


RECIPE = {}
RECIPE.uid = "gunpiperevolverrec"
RECIPE.name = "Pipe Revolver"
RECIPE.category = "Guns - Pipe Guns"
RECIPE.model = "models/illusion/fwp/w_piperevolver.mdl"
RECIPE.desc = "A scrap metal revolver for those unfortunate enough to not afford a real gun. Uses .38 ammunition."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
    ["wood"] = 2,
	["steel"] = 6,
	["screw"] = 2,
	["spring"] = 1,
	
}
RECIPE.result = {
    ["gun_piperevolver"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "gunpiperiflerec"
RECIPE.name = "Pipe Auto-Rifle"
RECIPE.category = "Guns - Pipe Guns"
RECIPE.model = "models/illusion/fwp/w_piperiflesemi.mdl"
RECIPE.desc = "A scrap metal rifle for those unfortunate enough to not afford a real gun. Uses .38 ammunition."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
    ["wood"] = 4,
	["steel"] = 10,
	["screw"] = 3,
	["spring"] = 1,
	
}
RECIPE.result = {
    ["gun_piperifle"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "gunpipeboltrec"
RECIPE.name = "Pipe Bolt Action"
RECIPE.category = "Guns - Pipe Guns"
RECIPE.model = "models/illusion/fwp/w_pipebolt.mdl"
RECIPE.desc = "A scrap bolt-action rifle for those unfortunate enough to not afford a real gun. Uses .38 ammunition."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
    ["wood"] = 4,
	["steel"] = 10,
	["screw"] = 3,
	["spring"] = 1,
	
}
RECIPE.result = {
    ["gun_pipeboltaction"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "gunpipesniperrec"
RECIPE.name = "Pipe Scoped Bolt Action"
RECIPE.category = "Guns - Pipe Guns"
RECIPE.model = "models/illusion/fwp/w_pipeboltscoped.mdl"
RECIPE.desc = "A scrap metal 'scoped' rifle for those unfortunate enough to not afford a real gun. Uses .38 ammunition."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
    ["wood"] = 4,
	["steel"] = 10,
	["screw"] = 3,
	["glass"] = 1,
	["spring"] = 1,
	
}
RECIPE.result = {
    ["gun_pipeboltactionscoped "] = 1
}
RECIPES:Register(RECIPE)

//





































-- gunsmith: gun Attachments

RECIPE = {}
RECIPE.uid = "9mmextmagrec"
RECIPE.name = "9mm Pistol Extended Magazine"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A longer double stacked magazine that increases the magazine size to 20."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 4,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["9mmextmag"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "9mmscoperec"
RECIPE.name = "9mm Pistol Scope"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short range 2x20 scope that is attached via a rail mount on the underside of the pistol."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 4,
    ["screw"] = 2,
	["spring"] = 1,
	["glass"] = 2,
	
}
RECIPE.result = {
    ["9mmscope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "9mmsmgdrumrec"
RECIPE.name = "name"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A drum magazine that increases magazine capacity from 30 to 60 rounds."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 3,
	["spring"] = 2,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["9mmsmgdrum"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "9mmsmglightboltrec"
RECIPE.name = "name"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A modified, shorter bolt that increases the fire rate of a 9mm SMG."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 1,
	["spring"] = 1,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["9mmsmglightbolt"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "10mmextmagrec"
RECIPE.name = "10mm Pistol Extended Magazine"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A long magazine that increases the round capacity of a 10mm pistol from 12 to 16."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 5,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["10mmextmag"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "10mmlaserrec"
RECIPE.name = "10mm Pistol Laser Sight"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A mounted laser sight that attaches over the weighted tube under the end of a 10mm pistol barrel, to assist with target acquisition."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 2,
    ["screw"] = 2,
	["glass"] = 2,
	["nuclearmaterial"] = 4,
	
}
RECIPE.result = {
    ["10mmlaser"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "10mmsilencerrec"
RECIPE.name = "10mm Pistol Silencer"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A barrel threading kit and threaded suppressor that attaches to the end of a 10mm pistol."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 5,
    ["screw"] = 3,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["10mmsilencer"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "10mmsmgextmagrec"
RECIPE.name = "10mm SMG Extended Magazine"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A long magazine that increases the round capacity of a 10mm SMG from 30 to 40."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 7,
    ["screw"] = 2,
	["spring"] = 2,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["10mmsmgextmag"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "10mmsmgcompensatorrec"
RECIPE.name = "10mm SMG Recoil Compensator"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A muzzle device that attaches to the barrel to reduce recoil and muzzle flip."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["10mmsmgcompensator"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "22smgdrumrec"
RECIPE.name = ".22 SMG Expanded Drum"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A drum magazine that increases the round capacity of a .22 SMG from 180 to 240."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 4,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["22smgdrum"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "44framerec"
RECIPE.name = ".44 Revolver Heavy Frame"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A heavy frame that allows for better recoil control."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["44frame"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "44scoperec"
RECIPE.name = ".44 Revolver Scope"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short range 1.86x scope that is mounted on top of the revolver."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 2,
	["glass"] = 3,
	
}
RECIPE.result = {
    ["44scope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "45apsliderec"
RECIPE.name = ".45 AP HD Slide"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A front weighted, heavy duty slide that helps drag the pistol down and counteract recoil."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 5,
    ["screw"] = 2,
	["spring"] = 2,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["45apslide"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "45apsilencerrec"
RECIPE.name = ".45 AP Silencer"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A barrel threading kit and threaded suppressor that attach to the end of a .45 AP Pistol."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["45apsilencer"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "45smgcompensatorrec"
RECIPE.name = ".45 Auto SMG Compensator"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A compensator that is attached to the end of an SMG barrel to help disperse muzzle flip and recoil."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 2,
	["spring"] = 1,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["45smgcompensator"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "45smgdrumrec"
RECIPE.name = ".45 Auto SMG Drum"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A drum magazine that increases the round capacity of a .45 AP SMG from 30 to 50."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 6,
    ["screw"] = 4,
	["spring"] = 3,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["45smgdrum"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "127pistolsilencerrec"
RECIPE.name = "12.7mm Pistol Silencer"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A barrel threading kit and large can suppressor that attach to the end of a 12.7mm Pistol."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 8,
    ["screw"] = 2,
	["spring"] = 3,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["127pistolsilencer"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "acextmagrec"
RECIPE.name = "Assault Carbine Extended Magazine"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A longer magazine that increases the magazine size from 30 to 42 rounds."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 8,
    ["screw"] = 4,
	["spring"] = 4,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["acextmag"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "acforgedreceiverrec"
RECIPE.name = "Assault Carbine Improved Sights"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A durable steel forged receiver with clearer sights on its carrying handle."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 10,
    ["screw"] = 4,
	["spring"] = 2,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["acforgedreceiver"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "aclightboltrec"
RECIPE.name = "Assault Carbine Light Bolt"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A modified, shorter bolt that increases the fire rate of an assault carbine."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["steel"] = 10,
    ["screw"] = 4,
	["spring"] = 2,
	["oil"] = 6,
	
}
RECIPE.result = {
    ["aclightbolt"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "amcfpartsrec"
RECIPE.name = "Anti-Mat CF Parts"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A carbon fiber replacement stock and grip that allows for easier handling."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 12,
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 4,
	["oil"] = 5,
	
}
RECIPE.result = {
    ["amcfparts"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "amcustomboltrec"
RECIPE.name = "Anti-Mat Custom Bolt"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A modified, shorter bolt that allows for faster bolting of rounds."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 2,
    ["screw"] = 8,
	["spring"] = 8,
	["steel"] = 12,
	["oil"] = 12,
	
}
RECIPE.result = {
    ["amcustombolt"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "amsuppressorrec"
RECIPE.name = "Anti-Mat Suppressor"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A barrel threading kit and threaded suppressor that attaches to the end of an Antimaterial Rifle."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 12,
	["oil"] = 6,
	
}
RECIPE.result = {
    ["amsuppressor"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "autorifleinternalsrec"
RECIPE.name = "Automatic Rifle Upgraded Internals"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An upgraded set of internal parts that increase the fire rate on automatic rifles."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 10,
	["spring"] = 10,
	["steel"] = 8,
	["oil"] = 6,
	
}
RECIPE.result = {
    ["autorifleinternals"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "brushgunreceiverrec"
RECIPE.name = "Brush Gun Forged Receiver"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An improved receiver that improves the lever action for easier recocking."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 14,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["brushgunreceiver"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "repeatermaplestockrec"
RECIPE.name = "Repeater Maple Stock"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A new, decorated Maple stock to allow for better control of the repeater."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["wood"] = 12,
    ["screw"] = 8,
	["spring"] = 2,
	["steel"] = 4,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["repeatermaplestock"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "repeatercustomactionrec"
RECIPE.name = "Repeater Custom Barrel"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An improved custom, long barrel that increases bullet velocity and gives rounds a flatter trajectory."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 10,
	["oil"] = 5,
	
}
RECIPE.result = {
    ["repeatercustomaction"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "repeaterlongtuberec"
RECIPE.name = "Repeater Long Tube"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A longer tube for loading more ammunition at a time."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 12,
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 4,
	["oil"] = 6,
	
}
RECIPE.result = {
    ["repeaterlongtube"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingrevolver6shotrec"
RECIPE.name = "Hunting Revolver 6 Shot Cylinder"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A larger cylinder to hold six rounds rather than five."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 3,
	["spring"] = 6,
	["steel"] = 18,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["huntingrevolver6shot"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingrevolvermatchbarrelrec"
RECIPE.name = "Hunting Revolver Match Barrel"
RECIPE.category = "Attachments - Pistols"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom made long barrel that increases accuracy on the revolver."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 8,
	["spring"] = 6,
	["steel"] = 16,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["huntingrevolvermatchbarrel"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingriflecustomactionrec"
RECIPE.name = "Hunting Rifle Custom Action"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom action that allows the bolt to cycle rounds faster."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 8,
	["spring"] = 4,
	["steel"] = 14,
	["oil"] = 6,
	
}
RECIPE.result = {
    ["huntingriflecustomaction"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingriflemagazinerec"
RECIPE.name = "Hunting Rifle Extended Magazine"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A larger magazine that holds ten rounds."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 2,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 12,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["huntingriflemagazine"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingriflescoperec"
RECIPE.name = "Hunting Rifle Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A long 3-9x40 scope meant to be attached to a hunting rifle."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["glass"] = 6,
	["steel"] = 6,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["huntingriflescope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingshotgunchokerec"
RECIPE.name = "Hunting Shotgun Choke"
RECIPE.category = "Attachments - Shotguns"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A muzzle choke placed at the end of the barrel that keeps pellet spread closer to increase accuracy."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 4,
	["spring"] = 4,
	["steel"] = 6,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["huntingshotgunchoke"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "huntingshotgunlongtuberec"
RECIPE.name = "Hunting Shotgun Long Tube"
RECIPE.category = "Attachments - Shotguns"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A tube magazine extension that allows for more shells to be loaded at a time to a hunting shotgun."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 2,
    ["screw"] = 2,
	["spring"] = 4,
	["steel"] = 6,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["huntingshotgunlongtube"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "lmgdrumrec"
RECIPE.name = "LMG Drum"
RECIPE.category = "Attachments - LMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A large drum magazine that holds a greater number of rounds than the typical box or belt."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["screw"] = 4,
	["spring"] = 8,
	["steel"] = 16,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["lmgdrum"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "servicerifleforgedrec"
RECIPE.name = "Service Rifle Forged Receiver"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom forged upper receiver for a service rifle that improves the durability of the weapon."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 12,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 8,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["servicerifleforged"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "serviceriflebarrelrec"
RECIPE.name = "Service Rifle Upgraded Barrel"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A longer barrel with custom rifling that improves the range and velocity of rounds."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["serviceriflebarrel"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "serviceriflescoperec"
RECIPE.name = "Service Rifle Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A 3.5x magnification scope, intended to be mounted on top of a service rifle carry handle."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["glass"] = 6,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["serviceriflescoperec"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "snipercfpartsrec"
RECIPE.name = "Sniper Rifle Carbon Fiber Parts"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of custom fiber parts that reduce the overall weight of the rifle."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 12,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 8,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["snipercfparts"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "snipersuppressorrec"
RECIPE.name = "Sniper Rifle Suppressor"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom suppressor mounted on a sniper rifle that drastically reduces the noise from firing a round."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 15,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["snipersuppressor"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "trailcarbinescoperec"
RECIPE.name = "Trail Carbine Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A precision mid-range scope with 3.5x magnification."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 12,
    ["glass"] = 6,
	["steel"] = 8,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["trailcarbinescope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "varmintriflextmagrec"
RECIPE.name = "Varmint Rifle Extended Magazine"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of longer fitting magazines for the Varmint Rifle that hold twice as many rounds before needing to be reloaded."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["varmintriflextmag"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "varmintriflenightscoperec"
RECIPE.name = "Varmint Rifle Night Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A telescopic sight that automatically detects whether or not to enable night vision depending on light conditions, and provides a green monochrome image for target acquisition at night."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
	["glass"] = 6,
	["steel"] = 10,
	["nuclearmaterial"] = 4,
	
}
RECIPE.result = {
    ["varmintriflenightscope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "varmintriflesilencerrec"
RECIPE.name = "Varmint Rifle Silencer"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom suppressor mounted on a varmint rifle that drastically reduces the noise from firing a round."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["varmintriflesilencer"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_handmaderiflescope"
RECIPE.name = "Handmade Assault Rifle Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A low magnification scope with a glowing reticle for the most common assault rifle in the wasteland."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 2,
    ["screw"] = 3,
	["glass"] = 3,
	["aluminum"] = 5,
	["oil"] = 1,
	["nuclearmaterial"] = 1,
	
}
RECIPE.result = {
    ["handmaderiflescope"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_handmaderiflebolt"
RECIPE.name = "Handmade Assault Rifle Custom Bolt"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom heavy bolt for the handmade assault rifle that improves its ballistic capabilities."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["spring"] = 3,
    ["screw"] = 3,
	["aluminum"] = 2,
	["steel"] = 8,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["handmaderiflebolt"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_handmaderiflemilled"
RECIPE.name = "Handmade Assault Rifle Milled Receiver"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A heavy duty milled receiver for the handmade assault rifle that increases durability."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 2,
	["aluminum"] = 4,
	["steel"] = 8,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["handmaderiflemilled"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_10mmsmgbarrel"
RECIPE.name = "10mm SMG Upgraded Barrel"
RECIPE.category = "Attachments - SMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A slightly longer barrel with a higher rifling twist rate that improves accuracy and damage."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 2,
	["steel"] = 10,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["10mmsmgbarrel"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_lmgheavybarrel"
RECIPE.name = "LMG Heavy Barrel"
RECIPE.category = "Attachments - LMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A heavy barrel for the LMG that drastically increases bullet velocity and damage output."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 6,
	["steel"] = 28,
	["aluminum"] = 6,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["lmgheavybarrel"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_lmgscope"
RECIPE.name = "LMG Scope"
RECIPE.category = "Attachments - LMGs"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short 2.5x magnification scope for the LMG. Improves accuracy."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 6,
	["steel"] = 6,
	["glass"] = 8,
	["aluminum"] = 8,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["lmgscope"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_r91scope"
RECIPE.name = "R91 Scope"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short 2x magnification scope for the R91."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 3,
	["steel"] = 4,
	["glass"] = 6,
	["aluminum"] = 3,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["r91scope"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_r91heavybarrel"
RECIPE.name = "R91 Heavy Barrel"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A heavy barrel for the R91 that improves bullet velocity and damage."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 8,
	["steel"] = 16,
	["aluminum"] = 4,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["r91heavybarrel"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_marksmanbarrel"
RECIPE.name = "Marksman Carbine Heavy Barrel"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A heavy barrel for the Marksman Carbine that improves bullet velocity and damage."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 8,
	["steel"] = 20,
	["aluminum"] = 6,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["marksmanbarrel"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_marksmanbolt"
RECIPE.name = "Marksman Carbine Custom Bolt"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A custom bolt for the marksman carbine that marginally increases chamber pressures for better damage."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["screw"] = 4,
	["spring"] = 6,
	["steel"] = 14,
	["aluminum"] = 4,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["marksmanbolt"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_marksmanrifling"
RECIPE.name = "Marksman Carbine Improved Rifling"
RECIPE.category = "Attachments - Rifles"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "Improves the rifling of a pre-existing barrel to increase accuracy on the marksman carbine."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["steel"] = 20,
	["aluminum"] = 10,
	["acid"] = 4,
	["oil"] = 4,
	
}
RECIPE.result = {
    ["marksmanrifling"] = 1
}
RECIPES:Register(RECIPE)

//











































------------------------------------------------ ARMOR SMITHING
//
RECIPE = {}
RECIPE.uid = "make_armoredvaultsuit"
RECIPE.name = "Armored Vault Suit"
RECIPE.category = "Armor - Special"
RECIPE.model = "models/fallout/apparel/vaultsuit.mdl"
RECIPE.desc = "An insulated vault suit modified with padding."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["rubber"] = 1,
    ["adhesive"] = 3,
	["leather"] = 3,
	["steel"] = 3,
	["armor_body_vaultsuit"] = 1,
	
}
RECIPE.result = {
    ["armor_body_armoredvaultsuit"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_leatherjacket"
RECIPE.name = "Leather Jacket"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/thespireroleplay/items/clothes/group051.mdl"
RECIPE.desc = "A tailored leather jacket."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_body_leatherjacket"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_leatherarmor"
RECIPE.name = "Leather Vest"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/thespireroleplay/items/clothes/group052.mdl"
RECIPE.desc = "A protective leather vest."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["leather"] = 3,
	["cloth"] = 3,
	
}
RECIPE.result = {
    ["armor_body_leatherarmor"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_leatherbrace"
RECIPE.name = "Leather Brace"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective leather armpads."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_arm_leather"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_reinforcedleatherbrace"
RECIPE.name = "Reinforced Leather Brace"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective leather armpads."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 2,
	["leather"] = 4,
	["cloth"] = 4,
	["steel"] = 4,
	["armor_arm_leather"] = 1,
	
}
RECIPE.result = {
    ["armor_arm_reinforcedleather"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_leathekneepad"
RECIPE.name = "Leather Kneepads"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective leather kneepads."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_leg_leather"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_reinforcedleatherkneepad"
RECIPE.name = "Reinforced Leather Kneepads"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective leather kneepads."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 2,
	["leather"] = 4,
	["cloth"] = 4,
	["steel"] = 4,
	["armor_leg_leather"] = 1,
	
}
RECIPE.result = {
    ["armor_leg_reinforcedleather"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_leatherreinforced"
RECIPE.name = "Reinforced Leather Jacket"
RECIPE.category = "Armor - Leather"
RECIPE.model = "models/thespireroleplay/items/clothes/group052.mdl"
RECIPE.desc = "A reinforced protective leather vest."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 2,
	["leather"] = 10,
	["cloth"] = 10,
	["steel"] = 20,
	["armor_body_leatherarmor"] = 1,
	
}
RECIPE.result = {
    ["armor_body_leatherreinforced"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_metalvest"
RECIPE.name = "Metal Vest"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/fallout/apparel/metalarmor.mdl"
RECIPE.desc = "A heavy, crudely fashioned metal vest."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 40,
	["cloth"] = 6,
	
}
RECIPE.result = {
    ["armor_body_metalvest"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_metalreinforced"
RECIPE.name = "Reinforced Metal Vest"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/fallout/apparel/metalarmor.mdl"
RECIPE.desc = "A heavy, crudely fashioned reinforced metal vest."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 2,
	["cloth"] = 10,
	["steel"] = 60,
	["armor_body_metalvest"] = 1,
	
}
RECIPE.result = {
    ["armor_body_metalreinforced"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_metalarm"
RECIPE.name = "Metal Armguard"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective metal armguards."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 20,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_arm_metal"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_reinforcedmetalarm"
RECIPE.name = "Reinforced Metal Armguard"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective metal armguards."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 30,
	["cloth"] = 2,
	["armor_arm_metal"] = 1,
	
}
RECIPE.result = {
    ["armor_arm_reinforcedmetal"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_metalleg"
RECIPE.name = "Metal Legguards"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective metal leg guards."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 20,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_leg_metal"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_reinforcedmetalleg"
RECIPE.name = "Reinforced Metal Legguards"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "A set of protective metal leg guards."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 30,
	["cloth"] = 2,
	["armor_leg_metal"] = 1,
	
}
RECIPE.result = {
    ["armor_leg_reinforcedmetal"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_metalhead"
RECIPE.name = "Metal Helmet"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/fallout/apparel/helmetmetalarmor.mdl"
RECIPE.desc = "A metal helmet."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 30,
	["cloth"] = 2,
	
}
RECIPE.result = {
    ["armor_head_metal"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_reinforcedmetalhead"
RECIPE.name = "Reinforced Metal Helmet"
RECIPE.category = "Armor - Metal"
RECIPE.model = "models/fallout/apparel/helmetmetalarmor.mdl"
RECIPE.desc = "A reinforced metal helmet."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["adhesive"] = 1,
	["steel"] = 40,
	["cloth"] = 2,
	["armor_head_metal"] = 1
	
}
RECIPE.result = {
    ["armor_head_reinforcedmetal"] = 1
}
RECIPES:Register(RECIPE)

//





------------------------------------------------ ARMOR UPGRADES
//
--[[ RECIPE = {}
RECIPE.uid = "armorupplate"
RECIPE.name = "Scrap Plate Covering"
RECIPE.category = "Armor - Padding and Inserts"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of raw scrap metal pieces welded together to be placed over armor, as additional protection."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["rubber"] = 4,
    ["screw"] = 4,
	["steel"] = 10,
	
}
RECIPE.result = {
    ["armorup_scrap"] = 1
}
RECIPES:Register(RECIPE) ]]

//


--[[ RECIPE = {}
RECIPE.uid = "armorupevasion"
RECIPE.name = "Weight Reduction Kit"
RECIPE.category = "Armor - Padding and Inserts"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of replacement fabrics and tools to reduce the overall weight of armor and clothing."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["rubber"] = 6,
    ["plastic"] = 6,
	["cloth"] = 8,
	
}
RECIPE.result = {
    ["armorup_evasion"] = 1
}
RECIPES:Register(RECIPE) ]]

//

--[[ RECIPE = {}
RECIPE.uid = "armorupenergy"
RECIPE.name = "Rubber Insulation Inserts"
RECIPE.category = "Armor - Padding and Inserts"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of custom inserts to be applied to, or inserted into clothing and armor to help protect from energy based damage."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["rubber"] = 12,
    ["plastic"] = 2,
	["cloth"] = 10,
	
}
RECIPE.result = {
    ["armorup_energy"] = 1
}
RECIPES:Register(RECIPE) ]]

//

--[[ RECIPE = {}
RECIPE.uid = "armorupballistic"
RECIPE.name = "Kevlar Inserts"
RECIPE.category = "Armor - Padding and Inserts"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A set of custom inserts to be applied to, or inserted into clothing and armor to help protect from physical/ballistic based damage."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["rubber"] = 2,
    ["ballisticfiber"] = 12,
	["cloth"] = 8,
	
}
RECIPE.result = {
    ["armorup_ballistic"] = 1
}
RECIPES:Register(RECIPE)
 ]]
//


















//
RECIPE = {}
RECIPE.uid = "bufftats"
RECIPE.name = "Bufftats"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fnv/props/health/chems/buffout.mdl"
RECIPE.desc = "A post-war pharmaceutical concoction that attempted to sell pills that not only effectively gave one strength, but also affected mental processing power to make you stronger, AND smarter than everyone else."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["drug_buffout"] = 1, 
    ["drug_mentats"] = 1,

}
RECIPE.result = {
    ["drug_bufftats"] = 1
}
RECIPES:Register(RECIPE)

//

//
RECIPE = {}
RECIPE.uid = "jet"
RECIPE.name = "Jet"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fallout4/props/aid/jet.mdl"
RECIPE.desc = "An small inhaler and canister filled with a highly addictive aerosol mixed chem."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["fertilizer"] = 3, 
    ["plastic"] = 2,

}
RECIPE.result = {
    ["drug_jet"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "jetfuel"
RECIPE.name = "Jetfuel"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fnv/props/health/chems/jet.mdl"
RECIPE.desc = "An small inhaler and canister filled with an extremely highly concentrated and potent form of Jet."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["drug_jet"] = 3, 
    ["j_abraxo"] = 1,
	["fertilizer"] = 1,

}
RECIPE.result = {
    ["drug_jetfuel"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "psycho"
RECIPE.name = "Psycho"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fallout4/props/aid/pyscho.mdl"
RECIPE.desc = "A syringe of military grade, psychosis-inducing amphetamines that were created prior to the Great War."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["acid"] = 2, 
    ["circuitry"] = 1,
	["medical_stimpack"] = 1,
	["food_bloodleaf"] = 1,

}
RECIPE.result = {
    ["drug_psycho"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "rebound"
RECIPE.name = "Rebound"
RECIPE.category = "Chems"
RECIPE.model = "modelpath"
RECIPE.desc = "desc."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["asbestos"] = 1, 
    ["acid"] = 1,
	["alc_whiskey"] = 1,

}
RECIPE.result = {
    ["drug_rebound"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "slasher"
RECIPE.name = "Slasher"
RECIPE.category = "Chems"
RECIPE.model = "modelpath"
RECIPE.desc = "A highly addictive wasteland mix of med-x and psycho."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["drug_psycho"] = 1, 
    ["drug_medx"] = 1,

}
RECIPE.result = {
    ["drug_slasher"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "steady"
RECIPE.name = "Steady"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fnv/props/health/chems/steady.mdl"
RECIPE.desc = "A combat chem poured into the bottom of a makeshift inhaler and tinfoil heating element, for roasting the chemical and inhaling the fumes."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["alc_moonshine"] = 1, 
    ["acid"] = 1,
	["food_cavefungus"] = 1,
}
RECIPE.result = {
    ["drug_steady"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "turbo"
RECIPE.name = "Turbo"
RECIPE.category = "Chems"
RECIPE.model = "models/mosi/fnv/props/health/chems/turbo.mdl"
RECIPE.desc = "A canister of jet rigged to a can of hairspray, as a makeshift, oversized aerosol propellant."
RECIPE.profession = "chef"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["drug_jet"] = 2, 
    ["plastic"] = 1,

}
RECIPE.result = {
    ["drug_turbo"] = 1
}
RECIPES:Register(RECIPE)

//



















----------------------------------------------------------------------
-- science: guns


RECIPE = {}
RECIPE.uid = "make_ammo_mfcovercharge"
RECIPE.name = "Microfusion Cells Over Charged"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/microfusion_cell.mdl"
RECIPE.desc = "A medium sized self-contained fusion plant for rifle-sized energy weapons. This one is overcharged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
	["lead"] = 4,
	
}
RECIPE.result = {
    ["ammo_mfcovercharge"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_ammo_mfc_maxcharge"
RECIPE.name = "Microfusion Cells Max Charge "
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/microfusion_cell.mdl"
RECIPE.desc = "A medium sized self-contained fusion plant for rifle-sized energy weapons. This one is fully charged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 5,
	["lead"] = 5,
	
}
RECIPE.result = {
    ["ammo_mfcmax"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_mfc"
RECIPE.name = "Microfusion Cells"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/microfusion_cell.mdl"
RECIPE.desc = "A medium sized self-contained fusion plant for rifle-sized energy weapons."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 3,
	["lead"] = 3,
	
}
RECIPE.result = {
    ["ammo_mfc"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_energycellovercharge"
RECIPE.name = "Energy Cells Over Charged"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/mosi/fallout4/ammo/gammaround.mdl"
RECIPE.desc = "A small self-contained energy unit for one-handed energy weapons. This one is fully charged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 3,
	["lead"] = 3,
	
}
RECIPE.result = {
    ["ammo_energycellovercharge"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_energycellmax"
RECIPE.name = "Energy Cells Max Charge"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/mosi/fallout4/ammo/gammaround.mdl"
RECIPE.desc = "A small self-contained energy unit for one-handed energy weapons. This one is fully charged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
	["lead"] = 4,
	
}
RECIPE.result = {
    ["ammo_energycellmax"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_energycell"
RECIPE.name = "Energy Cells"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/mosi/fallout4/ammo/gammaround.mdl"
RECIPE.desc = "A small self-contained energy unit for one-handed energy weapons."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 2,
	["lead"] = 2,
	
}
RECIPE.result = {
    ["ammo_energycell"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_ammo_ecpovercharge"
RECIPE.name = "Electron Charge Pack Overcharged"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/electron_charge_pack.mdl"
RECIPE.desc = "A small electron battery for rapid-firing energy weapons. This one is over charged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 5,
	["lead"] = 5,
	
}
RECIPE.result = {
    ["ammo_ecpovercharge"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_ecpmax"
RECIPE.name = "Electron Charge Pack Max Charge"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/electron_charge_pack.mdl"
RECIPE.desc = "A small electron battery for rapid-firing energy weapons. This one is fully charged."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
	["lead"] = 4,
	
}
RECIPE.result = {
    ["ammo_ecpmax"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_ammo_ecp"
RECIPE.name = "Electron Charge Pack - Max Charge"
RECIPE.category = "Science - Ammo"
RECIPE.model = "models/fallout new vegas/electron_charge_pack.mdl"
RECIPE.desc = "A small electron battery for rapid-firing energy weapons."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 3,
	["lead"] = 3,
	
}
RECIPE.result = {
    ["ammo_ecp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "laserpistolcombatsightrec"
RECIPE.name = "Laser Pistol Combat Sight"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "Luminscent dot iron sights that allow for enhanced accuracy."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
	["glass"] = 6,
	["steel"] = 6,
	["nuclearmaterial"] = 2,
	
}
RECIPE.result = {
    ["laserpistolcombatsight"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "laserpistolfocusopticrec"
RECIPE.name = "Laser Pistol Focus Optic"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An extension to the pistol's 'barrel' that places several focusing lenses to strengthen the output of outbound lasers."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 4,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["laserpistolfocusoptic"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "laserpistolrecyclerrec"
RECIPE.name = "Laser Pistol Recycler"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A module mounted to the back of the pistol which uses the 'action' of the laser pistol to generate charge for extra shots."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 6,
	["steel"] = 12,
	["oil"] = 2,
	["spring"] = 4,
	
}
RECIPE.result = {
    ["laserpistolrecycler"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_laserrevolvercombatsightrec"
RECIPE.name = "Laser Revolver Combat Sight"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "Luminscent dot iron sights that allow for enhanced accuracy."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
	["glass"] = 6,
	["steel"] = 6,
	["nuclearmaterial"] = 2,
	
}
RECIPE.result = {
    ["laserrevolvercombatsight"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_laserrevolverfocusopticrec"
RECIPE.name = "Laser Revolver Focus Optic"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An extension to the revolver's 'barrel' that places several focusing lenses to strengthen the output of outbound lasers."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 4,
	["steel"] = 10,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["laserrevolverfocusoptic"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_laserrevolverrecyclerrec"
RECIPE.name = "Laser Revolver Recycler"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A module mounted to the back of the revolver which uses the 'action' of the laser revolver to generate charge for extra shots."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 6,
	["steel"] = 12,
	["oil"] = 2,
	["spring"] = 4,
	
}
RECIPE.result = {
    ["laserrevolverrecycler"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "rcwrecyclerrec"
RECIPE.name = "Laser RCW Recycler"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A module mounted to the back of the drum pack which uses the 'action' of the RCW to generate charge for extra shots."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 6,
	["steel"] = 12,
	["oil"] = 2,
	["spring"] = 4,

	
}
RECIPE.result = {
    ["rcwrecycler"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "laserriflefocusopticsrec"
RECIPE.name = "Laser Rifle Focus Optics"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An extension to the rifle's 'barrel' that places several focusing lenses to strengthen the output of outbound lasers."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
    ["circuitry"] = 8,
	["steel"] = 12,
	["oil"] = 2,
	["spring"] = 4,
	
}
RECIPE.result = {
    ["laserriflefocusoptics"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "laserriflescoperec"
RECIPE.name = "Laser Rifle Scope"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A precision 3.5x magnification optic specifically designed to mount on top of laser rifles."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["glass"] = 6,
	["steel"] = 12,
	["oil"] = 2,
	["spring"] = 2,
	
}
RECIPE.result = {
    ["laserriflescope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "lasermusketscoperec"
RECIPE.name = "Laser Musket Scope"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short range scope for a Laser Musket to replace its basic iron sights."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 4,
    ["glass"] = 4,
	["steel"] = 10,
	["oil"] = 1,
	["spring"] = 1,
	
}
RECIPE.result = {
    ["lasermusketscope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "lasermusket2shotcaperec"
RECIPE.name = "Laser Musket 2 Shot Capacitor"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A short range scope for a Laser Musket to replace its basic iron sights."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["plastic"] = 6,
    ["circuitry"] = 8,
	["steel"] = 10,
	["acid"] = 4,
	["spring"] = 4,
	
}
RECIPE.result = {
    ["lasermusket2shotcap"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "laserrepeaterscope"
RECIPE.name = "Laser Repeater Scope"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A holographic sight for a Laser Repeater."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["plastic"] = 6,
    ["circuitry"] = 6,
	["steel"] = 10,
	["acid"] = 4,
    ["glass"] = 4,
	
}
RECIPE.result = {
    ["laserrepeaterscope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "plasmapistolionizerrec"
RECIPE.name = "Plasma Pistol Ionizer"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A pair of chambers that receive run-off gasses, improving the energy output of outgoing plasma."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 10,
    ["circuitry"] = 8,
	["steel"] = 14,
	["oil"] = 2,
	["spring"] = 4,
	
}
RECIPE.result = {
    ["plasmapistolionizer"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "plasmapistolmagaccrec"
RECIPE.name = "Plasma Pistol Magnetic Accelerator"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A front mounted set of probes that improve the projectile speed of plasma fired from the weapon, improving range."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
    ["circuitry"] = 8,
	["steel"] = 14,
	["acid"] = 4,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["plasmapistolmagacc"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "plasmapistolrecyclerrec"
RECIPE.name = "Plasma Pistol Recycler"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An improved set of tubes and chamber that recycles gasses released by the ionization process to allow for extra shots."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
    ["circuitry"] = 10,
	["steel"] = 12,
	["acid"] = 6,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["plasmapistolrecycler"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "plasmariflemagaccrec"
RECIPE.name = "Plasma Rifle Magnetic Accelerator"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A front mounted set of probes that improve the projectile speed of plasma fired from the weapon."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 10,
    ["circuitry"] = 10,
	["steel"] = 16,
	["acid"] = 6,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["plasmariflemagacc"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "plasmariflescoperec"
RECIPE.name = "Plasma Rifle Scope"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A 3.5x magnification precision scope, designed to be mounted on top of a plasma rifle."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
    ["glass"] = 8,
	["steel"] = 12,
	["acid"] = 6,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["plasmariflescope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "wattzfocusopticsrec"
RECIPE.name = "Wattz 3000 Focus Optics"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "An extension to the rifle's 'barrel' that places several focusing lenses to strengthen the output of outbound lasers."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 6,
    ["circuitry"] = 14,
	["steel"] = 14,
	["acid"] = 4,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["wattzfocusoptics"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "wattznightscoperec"
RECIPE.name = "Wattz 3000 Night Scope"
RECIPE.category = "Science - Attachments"
RECIPE.model = "models/mosi/fallout4/props/junk/modcrate.mdl"
RECIPE.desc = "A telescopic sight that automatically detects whether or not to enable night vision depending on light conditions, and provides a green monochrome image for target acquisition at night."
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 10,
    ["glass"] = 15,
	["steel"] = 10,
	["acid"] = 8,
	["spring"] = 6,
	
}
RECIPE.result = {
    ["wattznightscope"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_medical_bandages"
RECIPE.name = "Healing Powder"
RECIPE.category = "Science - Medical"
RECIPE.model = "models/maxib123/healingpowder.mdl"
RECIPE.desc = "Healing Powder +25HP"
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["food_brocflower"] = 1,
	["food_xanderroot"] = 1,
	
}
RECIPE.result = {
    ["medical_bandages"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_medical_stimpak"
RECIPE.name = "Healing Poultice"
RECIPE.category = "Science - Medical"
RECIPE.model = "models/maxib123/healingpowder.mdl"
RECIPE.desc = "Healing Poultice +50HP"
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["medical_bandages"] = 1,
	["food_cavefungus"] = 1,
	["food_agavefruit"] = 1,
	
}
RECIPE.result = {
    ["medical_stimpack"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_medical_accelerant"
RECIPE.name = "Potent Healing Poultice"
RECIPE.category = "Science - Medical"
RECIPE.model = "models/maxib123/healingpowder.mdl"
RECIPE.desc = "Potent Healing Poultice +100HP"
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["medical_bandages"] = 1,
	["food_cavefungus"] = 2,
	["food_agavefruit"] = 2,
	["food_xanderroot"] = 2,
	
}
RECIPE.result = {
    ["medical_stimpack"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_medical_firstaidkit"
RECIPE.name = "First Aid Kit"
RECIPE.category = "Science - Medical"
RECIPE.model = "models/mccarran/medbay/firstaidkit01.mdl"
RECIPE.desc = "First Aid Kit +75HP"
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["medical_bandages"] = 1,
	["cloth"] = 2,
	["plastic"] = 2,
	["food_agavefruit"] = 1,
	["food_xanderroot"] = 1,
	
}
RECIPE.result = {
    ["medical_firstaidkit"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_med_doctor"
RECIPE.name = "Doctor's Bag"
RECIPE.category = "Science - Medical"
RECIPE.model = "models/maxib123/doctorsbag.mdl"
RECIPE.desc = "Doctor's Bag Equipment Item"
RECIPE.profession = "science"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["medical_bandages"] = 1,
	["cloth"] = 5,
	["plastic"] = 5,
	["food_cavefungus"] = 1,
	["food_brocflower"] = 1,
	["food_agavefruit"] = 1,
	["food_xanderroot"] = 1,
	
}
RECIPE.result = {
    ["med_doctor"] = 1
}
RECIPES:Register(RECIPE)

//














---------------------------------------------------------

























-- Melee Mods

RECIPE = {}
RECIPE.uid = "make_meleedamageup"
RECIPE.name = "Melee Weight and Sharpening Kit"
RECIPE.category = "Melee - Upgrades"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "A kit which has the tools needed to add extra weight, or sharpening blades, for more lethality.\nDamage Bonus: 1."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 5,
	["steel"] = 10,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["enhance_weapon_meleedmg"] = 1
}
RECIPES:Register(RECIPE)

//


RECIPE = {}
RECIPE.uid = "make_meleeaccup"
RECIPE.name = "Melee Rebalancing Kit"
RECIPE.category = "Melee - Upgrades"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "A kit which has the tools needed to rebalance a melee weapon, for more precision and refined movement and handling.\nAccuracy Bonus: 1."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 5,
	["steel"] = 10,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["enhance_weapon_meleeacc"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_repair_20"
RECIPE.name = "Rusty Tool Roll"
RECIPE.category = "Weapons - Repair"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "(Repair  4)A kit which has the tools needed to repair a weapon. Repairs up to 20% durability."
RECIPE.profession = nil
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 3,
	["steel"] = 15,
	["oil"] = 1,
	
}
RECIPE.result = {
    ["repair_20"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_repair_40"
RECIPE.name = "Small Tool Bag"
RECIPE.category = "Weapons - Repair"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "(Repair  8) A kit which has the tools needed to repair a weapon. Repairs up to 40% durability."
RECIPE.profession = nil
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 5,
	["steel"] = 20,
	["oil"] = 2,
	
}
RECIPE.result = {
    ["repair_40"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_repair_60"
RECIPE.name = "Large Tool Bag"
RECIPE.category = "Weapons - Repair"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "(Repair  12) A kit which has the tools needed to repair a weapon. Repairs up to 60% durability."
RECIPE.profession = nil
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 8,
	["steel"] = 25,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["repair_60"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_repair_80"
RECIPE.name = "Field Repair Kit"
RECIPE.category = "Weapons - Repair"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "(Repair  16) A kit which has the tools needed to repair a weapon. Repairs up to 80% durability."
RECIPE.profession = nil
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 10,
	["steel"] = 30,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["repair_80"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_repair_100"
RECIPE.name = "Armorer's Kit"
RECIPE.category = "Weapons - Repair"
RECIPE.model = "models/mosi/fnv/props/health/repairkit.mdl"
RECIPE.desc = "(Repair  20) A kit which has the tools needed to repair a weapon. Repairs up to 100% durability."
RECIPE.profession = nil
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["plastic"] = 15,
	["steel"] = 40,
	["oil"] = 3,
	
}
RECIPE.result = {
    ["repair_100"] = 1
}
RECIPES:Register(RECIPE)

//




-- Ammosmithing

//
RECIPE = {}
RECIPE.uid = "make_charcoal"
RECIPE.name = "Make Charcoal"
RECIPE.category = "Ammo - Components"
RECIPE.model = "models/fallout3/furniture/campfire03.mdl"
RECIPE.desc = "A piece of charcoal"
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["wood"] = 1,
}
RECIPE.result = {
	["charcoal"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_gunpowder"
RECIPE.name = "Make Gunpowder"
RECIPE.category = "Ammo - Components"
RECIPE.model = "models/mosi/fnv/props/workstations/reloadingbench.mdl"
RECIPE.desc = "A mix of sulfur and charcoal"
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["charcoal"] = 1,
	["sulfur"] = 1,
}
RECIPE.result = {
	["gunpowder"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_22lr"
RECIPE.name = "22LR Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/fallout new vegas/22_ammo.mdl"
RECIPE.desc = "A box of .22LR ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 1,
}
RECIPE.result = {
	["ammo_22lr"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_22lrhp"
RECIPE.name = "22LR HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/fallout new vegas/22_ammo.mdl"
RECIPE.desc = "A box of .22LR HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 1,
}
RECIPE.result = {
	["ammo_22lrhp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_5mm"
RECIPE.name = "5mm Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/5mm.mdl"
RECIPE.desc = "A box of 5mm ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_5mm"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_5mmap"
RECIPE.name = "5mm AP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/5mm.mdl"
RECIPE.desc = "A box of 5mm AP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_5mmap"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_5mmhp"
RECIPE.name = "5mm HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/5mm.mdl"
RECIPE.desc = "A box of 5mm HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_5mmhp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_5mmsurplus"
RECIPE.name = "5mm Surplus Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/5mm.mdl"
RECIPE.desc = "A box of 5mm Surplus ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 1,
}
RECIPE.result = {
	["ammo_5mmsurplus"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_38"
RECIPE.name = "38 Special Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/38.mdl"
RECIPE.desc = "A box of 38 Special ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_38"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_38hp"
RECIPE.name = "38 Special HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/38.mdl"
RECIPE.desc = "A box of 38 Special HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_38hp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_9mm"
RECIPE.name = "9mm Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/illusion/fwp/9mmammo.mdl"
RECIPE.desc = "A box of 9mm ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_9mm"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_9mmhp"
RECIPE.name = "9mm HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/illusion/fwp/9mmammo.mdl"
RECIPE.desc = "A box of 9mm HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_9mmhp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_9mmplus"
RECIPE.name = "9mm +P Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/illusion/fwp/9mmammo.mdl"
RECIPE.desc = "A box of 9mm +P ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_9mmhp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_10mm"
RECIPE.name = "10mm Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/10mm.mdl"
RECIPE.desc = "A box of 10mm ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_10mm"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_10mmhp"
RECIPE.name = "10mm HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/10mm.mdl"
RECIPE.desc = "A box of 10mm HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
}
RECIPE.result = {
	["ammo_10mm"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_45auto"
RECIPE.name = "45 Auto Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/45.mdl"
RECIPE.desc = "A box of 45 Auto ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["steel"] = 2,
}
RECIPE.result = {
	["ammo_45auto"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_45autohp"
RECIPE.name = "45 Auto HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/45.mdl"
RECIPE.desc = "A box of 45 Auto HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["steel"] = 2,
}
RECIPE.result = {
	["ammo_45autohp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_45autoplus"
RECIPE.name = "45 Auto +P Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/45.mdl"
RECIPE.desc = "A box of 45 Auto +P ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["steel"] = 2,
}
RECIPE.result = {
	["ammo_45autoplus"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_20g"
RECIPE.name = "20 Gauge Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/fallout new vegas/shotgun_ammo.mdl"
RECIPE.desc = "A box of 20 Gauge ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 1,
	["plastic"] = 1,
}
RECIPE.result = {
	["ammo_20g"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_12g"
RECIPE.name = "12 Gauge Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/shotgunshells.mdl"
RECIPE.desc = "A box of 12 Gauge ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
	["plastic"] = 1,
}
RECIPE.result = {
	["ammo_12g"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_12gdragon"
RECIPE.name = "12 Gauge Dragon's Breath Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/shotgunshells.mdl"
RECIPE.desc = "A box of 12 Gauge Dragon's Breath ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 2,
	["plastic"] = 1,
	["aluminum"] = 2,
}
RECIPE.result = {
	["ammo_12dragon"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_12gexplosive"
RECIPE.name = "12 Gauge Explosive Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/shotgunshells.mdl"
RECIPE.desc = "A box of 12 Gauge Explosive ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 5,
	["lead"] = 2,
	["plastic"] = 1,
}
RECIPE.result = {
	["ammo_12explosive"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_12gflechette"
RECIPE.name = "12 Gauge Flechette Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/shotgunshells.mdl"
RECIPE.desc = "A box of 12 Gauge Flechette ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 3,
	["plastic"] = 2,
}
RECIPE.result = {
	["ammo_12flechette"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_12grubber"
RECIPE.name = "12 Gauge Rubber Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/shotgunshells.mdl"
RECIPE.desc = "A box of 12 Gauge Rubber ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["rubber"] = 2,
	["plastic"] = 2,
}
RECIPE.result = {
	["ammo_12rubber"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_357magnum"
RECIPE.name = "357 Magnum Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/items/357ammo.mdl"
RECIPE.desc = "A box of 357 Magnum ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["steel"] = 2,
}
RECIPE.result = {
	["ammo_357"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_357magnumhp"
RECIPE.name = "357 Magnum HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/items/357ammo.mdl"
RECIPE.desc = "A box of 357 Magnum HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["steel"] = 2,
}
RECIPE.result = {
	["ammo_357hp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_44magnum"
RECIPE.name = "44 Magnum Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/44.mdl"
RECIPE.desc = "A box of 44 Magnum ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 1,
	["steel"] = 2,
	["copper"] = 2,
}
RECIPE.result = {
	["ammo_44"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_44magnumhp"
RECIPE.name = "44 Magnum HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/44.mdl"
RECIPE.desc = "A box of 44 Magnum HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["steel"] = 2,
	["copper"] = 2,
}
RECIPE.result = {
	["ammo_44hp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_44magnumswc"
RECIPE.name = "44 Magnum SWC Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/44.mdl"
RECIPE.desc = "A box of 44 Magnum SWC ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["steel"] = 2,
	["copper"] = 1,
}
RECIPE.result = {
	["ammo_44swc"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_556"
RECIPE.name = "5.56 Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/556.mdl"
RECIPE.desc = "A box of 5.56 ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 3,
}
RECIPE.result = {
	["ammo_556"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_556ap"
RECIPE.name = "5.56 AP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/556.mdl"
RECIPE.desc = "A box of 5.56 AP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 3,
}
RECIPE.result = {
	["ammo_556ap"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_556hp"
RECIPE.name = "5.56 HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/556.mdl"
RECIPE.desc = "A box of 5.56 HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 3,
}
RECIPE.result = {
	["ammo_556hp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_308"
RECIPE.name = ".308 Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/308.mdl"
RECIPE.desc = "A box of .308 ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 2,
	["lead"] = 3,
	["copper"] = 1,
}
RECIPE.result = {
	["ammo_308"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_308ap"
RECIPE.name = ".308 AP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/308.mdl"
RECIPE.desc = "A box of .308 AP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 3,
	["copper"] = 2,
}
RECIPE.result = {
	["ammo_308ap"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_4570"
RECIPE.name = ".45-70 Gov't Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/Items/BoxSRounds.mdl"
RECIPE.desc = "A box of .45-70 Gov't ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["steel"] = 3,
	["copper"] = 2,
}
RECIPE.result = {
	["ammo_4570"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_4570hp"
RECIPE.name = ".45-70 Gov't HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/Items/BoxSRounds.mdl"
RECIPE.desc = "A box of .45-70 Gov't HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 4,
	["steel"] = 3,
	["copper"] = 3,
}
RECIPE.result = {
	["ammo_4570hp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_4570swc"
RECIPE.name = ".45-70 Gov't SWC Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/Items/BoxSRounds.mdl"
RECIPE.desc = "A box of .45-70 Gov't SWC ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 4,
	["steel"] = 2,
	["copper"] = 2,
}
RECIPE.result = {
	["ammo_4570swc"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_127mm"
RECIPE.name = "12.7mm Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/illusion/fwp/127ammobox.mdl"
RECIPE.desc = "A box of 12.7mm ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 3,
	["lead"] = 3,
	["copper"] = 3,
}
RECIPE.result = {
	["ammo_127mm"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_127mmhp"
RECIPE.name = "12.7mm HP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/illusion/fwp/127ammobox.mdl"
RECIPE.desc = "A box of 12.7mm HP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 4,
	["lead"] = 3,
	["copper"] = 3,
}
RECIPE.result = {
	["ammo_127mmhp"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_50mg"
RECIPE.name = ".50 MG Ammo"
RECIPE.category = "Ammo - Standard Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/50.mdl"
RECIPE.desc = "A box of .50 MG ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 5,
	["lead"] = 5,
	["copper"] = 5,
}
RECIPE.result = {
	["ammo_50mg"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_50mgap"
RECIPE.name = ".50 MG AP Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/50.mdl"
RECIPE.desc = "A box of .50 MG AP ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 6,
	["lead"] = 5,
	["copper"] = 6,
}
RECIPE.result = {
	["ammo_50mgap"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_50mgexplosive"
RECIPE.name = ".50 MG Explosive Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/50.mdl"
RECIPE.desc = "A box of .50 MG Explosive ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 10,
	["lead"] = 6,
	["copper"] = 6,
}
RECIPE.result = {
	["ammo_50mgexplosive"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_50mgincendiary"
RECIPE.name = ".50 MG Incendiary Ammo"
RECIPE.category = "Ammo - Special Ammo Types"
RECIPE.model = "models/mosi/fallout4/ammo/50.mdl"
RECIPE.desc = "A box of .50 MG Incendiary ammo."
RECIPE.profession = "gunsmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["gunpowder"] = 6,
	["lead"] = 6,
	["copper"] = 6,
	["aluminum"] = 2,
	["oil"] = 2, 
}
RECIPE.result = {
	["ammo_50mgincendiary"] = 1
}
RECIPES:Register(RECIPE)

//

-- BLACKSMITH RECIPES

RECIPE = {}
RECIPE.uid = "make_spikedwalkingcane"
RECIPE.name = "Spiked Walking Cane"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/walkingcane.mdl"
RECIPE.desc = "A makeshift weapon combining a walking cane and spikes."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["steel"] = 5,
	["screw"] = 2,
	["melee_walkingcane"] =1,
}
RECIPE.result = {
	["melee_spikedwalkingcane"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_bladedrollingpin"
RECIPE.name = "Bladed Rolling Pin"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/rollingpin.mdl"
RECIPE.desc = "A makeshift weapon made by attaching blades to a rolling pin."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["steel"] = 5,
	["screw"] = 2,
	["melee_rollingpin"] = 1,
}
RECIPE.result = {
	["melee_bladedrollingpin"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_combatknife"
RECIPE.name = "Combat Knife"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/walkingcane.mdl"
RECIPE.desc = "A makeshift combat knife forged out of steel."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["steel"] = 15,
	["screw"] = 2,
}
RECIPE.result = {
	["melee_combatknife"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_hookedwrench"
RECIPE.name = "Hooked Wrench"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/pipewrench.mdl"
RECIPE.desc = "A makeshift wrench combined with several hooks."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 2,
	["steel"] = 20,
	["screw"] = 2,
	["melee_wrench"] = 1,
}
RECIPE.result = {
	["melee_hookedwrench"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_spikedbat"
RECIPE.name = "Spiked Bat"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl"
RECIPE.desc = "A makeshift weapon created by drilling spikes into a wooden bat."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 2,
	["steel"] = 20,
	["lead"] = 5,
	["screw"] = 2,
	["melee_baseballbat"] = 1,
}
RECIPE.result = {
	["melee_spikedbat"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_bladedbat"
RECIPE.name = "Bladed Bat"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl"
RECIPE.desc = "A makeshift weapon created by attaching blades onto a wooden bat."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 2,
	["steel"] = 20,
	["aluminum"] = 5,
	["screw"] = 2,
	["melee_baseballbat"] = 1,
}
RECIPE.result = {
	["melee_bladedbat"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_barbwirebat"
RECIPE.name = "Barbwire Bat"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl"
RECIPE.desc = "A makeshift weapon created by wrapping barbed wire around a wooden bat."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 2,
	["steel"] = 25,
	["screw"] = 2,
	["melee_baseballbat"] = 1,
}
RECIPE.result = {
	["melee_barbwirebat"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_metalrazorbat"
RECIPE.name = "Metal Razor Bat"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl"
RECIPE.desc = "A makeshift weapon created by installing razor blades around a metal bat."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 3,
	["steel"] = 25,
	["aluminum"] = 5,
	["screw"] = 3,
	["melee_metalbaseballbat"] = 1,
}
RECIPE.result = {
	["melee_metalrazorbat"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_metalchainedbat"
RECIPE.name = "Metal Chained Bat"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl"
RECIPE.desc = "A makeshift weapon created by wrapping chains around a metal bat."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 3,
	["steel"] = 30,
	["screw"] = 3,
	["melee_metalbaseballbat"] = 1,
}
RECIPE.result = {
	["melee_metalchainedbat"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_board"
RECIPE.name = "Wooden Board"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/board.mdl"
RECIPE.desc = "A makeshift weapon made out of wood."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["wood"] = 5,
	["screw"] = 2,
}
RECIPE.result = {
	["melee_board"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_bladedboard"
RECIPE.name = "Bladed Board"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/board.mdl"
RECIPE.desc = "A makeshift weapon made out of attaching blades to a board."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["aluminum"] = 5,
	["screw"] = 2,
	["melee_board"] = 1,
}
RECIPE.result = {
	["melee_bladedboard"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_spikedboard"
RECIPE.name = "Spiked Board"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/board.mdl"
RECIPE.desc = "A makeshift weapon made out of attaching spikes to a board."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["lead"] = 5,
	["screw"] = 2,
	["melee_board"] = 1,
}
RECIPE.result = {
	["melee_spikedboard"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_serratedboard"
RECIPE.name = "Serrated Board"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/board.mdl"
RECIPE.desc = "A makeshift weapon made out of attaching a serrated blade to a board."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["aluminum"] = 10,
	["screw"] = 2,
	["melee_board"] = 1,
}
RECIPE.result = {
	["melee_serratedboard"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_machete"
RECIPE.name = "Machete"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/machete.mdl"
RECIPE.desc = "A makeshift weapon created forging steel and attaching a handle."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 3,
	["steel"] = 25,
	["screw"] = 3,
	["leather"] = 1,
}
RECIPE.result = {
	["melee_machete"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_tireironaxe"
RECIPE.name = "Tire Iron Axe"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/tireiron.mdl"
RECIPE.desc = "A makeshift weapon created by attaching an axe blade to a tire iron."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 4,
	["steel"] = 30,
	["screw"] = 4,
	["leather"] = 1,
}
RECIPE.result = {
	["melee_tireironaxe"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_polehook"
RECIPE.name = "Pole Hook"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/polehook.mdl"
RECIPE.desc = "A makeshift weapon created by attaching a hook to a metal pole."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 3,
	["steel"] = 15,
	["aluminum"] = 15,
	["screw"] = 3,
}
RECIPE.result = {
	["melee_polehook"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_poolcuespear"
RECIPE.name = "Pool Cue Spear"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/poolcue.mdl"
RECIPE.desc = "A makeshift weapon created by attaching a spike to a pool cue."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 3,
	["steel"] = 10,
	["lead"] = 5,
	["screw"] = 3,
	["j_poolcue"] = 1,
}
RECIPE.result = {
	["melee_poolcuespear"] = 1
}
RECIPES:Register(RECIPE)

//

RECIPE = {}
RECIPE.uid = "make_poolcuespearandshield"
RECIPE.name = "Pool Cue Spear and Shield"
RECIPE.category = "Weapons - Melee"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/poolcue.mdl"
RECIPE.desc = "A makeshift weapon created by attaching a spike to a pool cue and wielding a sheet metal shield."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["steel"] = 30,
	["melee_poolcuespear"] =1,
}
RECIPE.result = {
	["melee_poolcuespearandshield"] = 1
}
RECIPES:Register(RECIPE)

//

-- throwing weapons

RECIPE = {}
RECIPE.uid = "make_throwing_knife"
RECIPE.name = "Throwing Knife"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/mosi/fallout4/props/weapons/melee/knife.mdl"
RECIPE.desc = "A weighted, thin blade with no handle, meant for throwing."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["wood"] = 1,
	["steel"] = 5,
	["screw"] = 1,
}
RECIPE.result = {
	["throwing_knife"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_throwing_hatchet"
RECIPE.name = "Throwing Hatchet"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/fo3_axe.mdl"
RECIPE.desc = "A short hatchet weighted and balanced to be thrown."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["wood"] = 2,
	["steel"] = 10,
	["screw"] = 1,
}
RECIPE.result = {
	["throwing_knife"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_throwing_spear"
RECIPE.name = "Throwing Spear"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/halokiller38/fallout/weapons/melee/bm_spear.mdl"
RECIPE.desc = "A makeshift weapon created by attaching a spike to a wooden pole."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["wood"] = 3,
	["steel"] = 15,
	["screw"] = 1,
}
RECIPE.result = {
	["throwing_spear"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_grenade_dynamite"
RECIPE.name = "Dynamite"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/halokiller38/fallout/weapons/explosives/dynamite.mdl"
RECIPE.desc = "A makeshift stick of dynamite."
RECIPE.profession = "science"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["cloth"] = 1,
	["gunpowder"] = 4,
}
RECIPE.result = {
	["grenade_dynamite"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_grenade_tincan"
RECIPE.name = "Tin Can Grenade"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/mosi/fnv/props/junk/tincan01.mdl"
RECIPE.desc = "A makeshift grenade made with a tin can."
RECIPE.profession = "science"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["cloth"] = 1,
	["gunpowder"] = 3,
	["steel"] = 5,
}
RECIPE.result = {
	["grenade_tincan"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_grenade_mfcgrenade"
RECIPE.name = "Microfusion Cell Grenade"
RECIPE.category = "Throwing Weapons"
RECIPE.model = "models/mosi/fallout4/ammo/microfusioncell.mdl"
RECIPE.desc = "A makeshift grenade made a microfusion cell."
RECIPE.profession = "science"
RECIPE.xp = 0.01
RECIPE.items = {
	["adhesive"] = 1,
	["gunpowder"] = 3,
	["plastic"] = 4,
}
RECIPE.result = {
	["grenade_mfcgrenade"] = 1
}
RECIPES:Register(RECIPE)

//

-- bobbybin entry


RECIPE = {}
RECIPE.uid = "make_bobbypin"
RECIPE.name = "Bobbybin"
RECIPE.category = "Miscelaneous"
RECIPE.model = "models/mosi/fallout4/props/junk/bobbypin.mdl"
RECIPE.desc = "A makeshift bobbypin."
RECIPE.profession = nil
RECIPE.xp = 0.00
RECIPE.items = {
	["steel"] = 3,
}
RECIPE.result = {
	["bobbypin"] = 1
}
RECIPES:Register(RECIPE)

//

-- backpack entry

RECIPE = {}
RECIPE.uid = "make_smallpack"
RECIPE.name = "Small Backpack"
RECIPE.category = "Storage"
RECIPE.model = "models/vex/fallout76/backpacks/backpack_01.mdl"
RECIPE.desc = "A small makeshift backpack."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["leather"] = 3,
	["cloth"] = 3,
	["adhesive"] = 3,
}
RECIPE.result = {
	["smallpack"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_mediumpack"
RECIPE.name = "Medium Backpack"
RECIPE.category = "Storage"
RECIPE.model = "models/vex/fallout76/backpacks/atx_backpack_pioneer.mdl"
RECIPE.desc = "A medium makeshift backpack."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["leather"] = 9,
	["cloth"] = 9,
	["adhesive"] = 4,
}
RECIPE.result = {
	["mediumpack"] = 1
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_largepack"
RECIPE.name = "Large Backpack"
RECIPE.category = "Storage"
RECIPE.model = "models/vex/fallout76/backpacks/atx_backpack_surplussack.mdl"
RECIPE.desc = "A large makeshift backpack."
RECIPE.profession = "blacksmith"
RECIPE.xp = 0.01
RECIPE.items = {
	["leather"] = 27,
	["cloth"] = 27,
	["adhesive"] = 5,
}
RECIPE.result = {
	["largepack"] = 1
}
RECIPES:Register(RECIPE)

//
-------- breaking down weapons 
RECIPE = {}
RECIPE.uid = "make_breakdown9mmpistol"
RECIPE.name = "Breakdown 9mm Pistol"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_9mmpistol"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown22pistol"
RECIPE.name = "Breakdown 22 Pistol"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_22lrpistol"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown22smg"
RECIPE.name = "Breakdown 22 SMG"
RECIPE.category = "Breakdown - Weapon (SMGs)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_22lrsmg"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownchinesesmg"
RECIPE.name = "Breakdown Chinese SMG"
RECIPE.category = "Breakdown - Weapon (SMGs)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_22chinesesmg"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 3,
	["wood"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown9mmsmg"
RECIPE.name = "Breakdown 9mm SMG"
RECIPE.category = "Breakdown - Weapon (SMGs)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_9mmsmg"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownauxrevolver"
RECIPE.name = "Breakdown Auxiliary Revolver"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_auxilaryrevolver"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 2,
	["wood"] = 2,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownlightcarbine"
RECIPE.name = "Breakdown Light Carbine"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_lightcarbine"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 3,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownrevolvingcarbine"
RECIPE.name = "Breakdown Revolving Carbine"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_revolvingcarbine"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 3,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownscoutrifle"
RECIPE.name = "Breakdown Scout Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_scoutrifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 3,
	["wood"] = 4,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown38revolver"
RECIPE.name = "Breakdown 38 Revolver"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_38revolver"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 2,
	["wood"] = 2,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownvarmintrifle"
RECIPE.name = "Breakdown Varmint Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_varmintrifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowncaravanshotgun"
RECIPE.name = "Breakdown Caravan Shotgun"
RECIPE.category = "Breakdown - Weapon (Shotguns)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_caravanshotgun"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 3,
	["wood"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownhuntingshotgun"
RECIPE.name = "Breakdown Hunting Shotgun"
RECIPE.category = "Breakdown - Weapon (Shotguns)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_huntingshotgun"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownservicerifle"
RECIPE.name = "Breakdown Service Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_servicerifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown45pistol"
RECIPE.name = "Breakdown 45 Pistol"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_45pistol"] = 1
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 3,
	["wood"] = 2,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown45smg"
RECIPE.name = "Breakdown 45 SMG"
RECIPE.category = "Breakdown - Weapon (SMGs)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_submachinegun"] = 1
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 4,
	["wood"] = 4,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdown10mmpistol"
RECIPE.name = "Breakdown 10mm Pistol"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_10mmpistol"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 4,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "make_breakdown10mmsmg"
RECIPE.name = "Breakdown 10mm SMG"
RECIPE.category = "Breakdown - Weapon (SMGs)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_10mmsmg"] = 1
	
}
RECIPE.result = {
    ["steel"] = 7,
	["screw"] = 4,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowncombatrifle"
RECIPE.name = "Breakdown Combat Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_combatrifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 4,
	["wood"] = 4,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "make_breakdownhandmadear"
RECIPE.name = "Breakdown Handmade AR"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_handemadear"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 6,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "make_breakdownstampedmg"
RECIPE.name = "Breakdown Stamped MG"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_assaultrifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 7,
	["screw"] = 5,
	["aluminum"] = 3,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "make_breakdown357revolver"
RECIPE.name = "Breakdown 357 Revolver"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_357magnum"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleveraction"
RECIPE.name = "Breakdown Lever Action Shotgun"
RECIPE.category = "Breakdown - Weapon (Shotguns)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_leveractionshotgun"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 7,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_auxiliaryrifle"
RECIPE.name = "Breakdown Auxiliary Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_auxiliaryrifle"] = 1
	
}
RECIPE.result = {
    ["steel"] = 5,
	["screw"] = 4,
	["wood"] = 5,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowcowboyrepeater"
RECIPE.name = "Breakdown Cowboy Repeater"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_cowboyrepeater"] = 1
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 4,
	["wood"] = 8,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)
//
RECIPE = {}
RECIPE.uid = "make_breakdowngunpiperevolverrec"
RECIPE.name = "Breakdown Pipe Revolver"
RECIPE.category = "Breakdown - Weapon (Pistols)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_piperevolver"] = 1
	
}
RECIPE.result = {
    ["steel"] = 3,
	["screw"] = 1,
	["spring"] = 1,
	["wood"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowngunpiperiflerec"
RECIPE.name = "Breakdown Pipe Rifle"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_piperifle"] = 1,
	
}
RECIPE.result = {
    ["steel"] = 4,
	["screw"] = 1,
	["spring"] = 1,
	["wood"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowngunpipeboltrec"
RECIPE.name = "Breakdown Pipe Bolt Action"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_pipeboltaction"] = 1,
	
}
RECIPE.result = {
    ["steel"] = 6,
	["screw"] = 2,
	["spring"] = 2,
	["wood"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowngunpipesniperrec"
RECIPE.name = "Breakdown Pipe Scoped Bolt Action"
RECIPE.category = "Breakdown - Weapon (Rifles)"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "gunsmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["gun_pipeboltactionscoped"] = 1,
	
}
RECIPE.result = {
    ["wood"] = 2,
	["steel"] = 6,
	["screw"] = 3,
	["glass"] = 1,
	["spring"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownboxingglove"
RECIPE.name = "Breakdown Boxing Glove"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_boxingglove"] = 1,
}
RECIPE.result = {
    ["leather"] = 3,
	["adhesive"] = 1,
	["cloth"] = 3
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownswitchblade"
RECIPE.name = "Breakdown Switchblade"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_switchblade"] = 1,
	
}
RECIPE.result = {
    ["steel"] = 3,
	["spring"] = 1,
	["screw"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowncombatknife"
RECIPE.name = "Breakdown Combat Knife"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_combatknife"] = 1
	
}
RECIPE.result = {
	["steel"] = 6
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleadpipe"
RECIPE.name = "Breakdown Lead Pipe"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_leadpipe"] = 1
	
}
RECIPE.result = {
    ["lead"] = 4
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownwoodenboard"
RECIPE.name = "Breakdown Wooden Board"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_board"] = 1
	
}
RECIPE.result = {
    ["wood"] = 3
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownwalkingcane"
RECIPE.name = "Breakdown Walking Cane"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_walkingcane"] = 1
	
}
RECIPE.result = {
    ["wood"] = 3
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownwrench"
RECIPE.name = "Breakdown Wrench"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_wrench"] = 1
	
}
RECIPE.result = {
	["steel"] = 4,
	["screw"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdowncommiewhacker"
RECIPE.name = "Breakdown Commie Whacker"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_commiewhacker"] = 1
	
}
RECIPE.result = {
    ["rubber"] = 2,
	["wood"] = 4,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownbaseballbat"
RECIPE.name = "Breakdown Baseball Bat"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_baseballbat"] = 1
	
}
RECIPE.result = {
    ["wood"] = 10,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownspikedwalkingcane"
RECIPE.name = "Breakdown Spiked Walking Cane"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_spikedwalkingcane"] = 1
	
}
RECIPE.result = {
    ["wood"] = 3,
	["steel"] = 1,
	["adhesive"] = 1,
	["screw"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownbladedrollingpin"
RECIPE.name = "Breakdown Bladed Rolling Pin"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_bladedrollingpin"] = 1
	
}
RECIPE.result = {
    ["wood"] = 2,
	["adhesive"] = 1,
	["steel"] = 3,
	["screw"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownbladedcommiewhacker"
RECIPE.name = "Breakdown Bladed Commie Whacker"
RECIPE.category = "Breakdown - Melee Weapons"
RECIPE.model = "models/fallout3/clutter/scrapmetal.mdl"
RECIPE.desc = "Crudely break down the materials of weapons."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["melee_bladedcommiewhacker"] = 1
	
}
RECIPE.result = {
    ["wood"] = 2,
	["adhesive"] = 1,
	["steel"] = 3,
	["screw"] = 1,
	["rubber"] = 2,
}
RECIPES:Register(RECIPE)

//
----- breakdown armor
RECIPE = {}
RECIPE.uid = "make_breakdownleatherjacket"
RECIPE.name = "Breakdown Leather Jacket"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/thespireroleplay/items/clothes/group051.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_body_leatherjacket"] = 1
	
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleatherarmor"
RECIPE.name = "Breakdown Leather Vest"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/thespireroleplay/items/clothes/group052.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_body_leatherarmor"] = 1
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 3,
	["cloth"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleatherbrace"
RECIPE.name = "Breakdown Leather Brace"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_arm_leather"] = 1
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownreinforcedleatherbrace"
RECIPE.name = "Breakdown Reinforced Leather Brace"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_arm_reinforcedleather"] = 1
	
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 4,
	["cloth"] = 2,
	["steel"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleathekneepad"
RECIPE.name = "Breakdown Leather Kneepads"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_leg_leather"] = 1
	
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 2,
	["cloth"] = 1,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownreinforcedleatherkneepad"
RECIPE.name = "Breakdown Reinforced Leather Kneepads"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/mosi/fallout4/props/junk/ammobag.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
    ["armor_leg_reinforcedleather"] = 1

}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 4,
	["cloth"] = 2,
	["steel"] = 2,
}
RECIPES:Register(RECIPE)

//
RECIPE = {}
RECIPE.uid = "make_breakdownleatherreinforced"
RECIPE.name = "Breakdown Reinforced Leather Jacket"
RECIPE.category = "Breakdown Armor"
RECIPE.model = "models/thespireroleplay/items/clothes/group052.mdl"
RECIPE.desc = "Crudely break down the materials of armor."
RECIPE.profession = "blacksmith"
RECIPE.items = {
    --uniqueID, if unspecified in the file, are the file name without the sh_
	["armor_body_leatherreinforced"] = 1
	
}
RECIPE.result = {
    ["adhesive"] = 1,
	["leather"] = 10,
	["cloth"] = 5,
	["steel"] = 10,
}
RECIPES:Register(RECIPE)

//










