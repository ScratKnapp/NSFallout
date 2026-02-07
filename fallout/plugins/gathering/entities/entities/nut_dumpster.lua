ENT.Type = "anim"
ENT.Base = "nut_gathering"
ENT.PrintName = "Dumpster"
ENT.Author = "" --Weird modifications by chancer
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Gathering"

ENT.xpGain = 0.25

ENT.Name = "Dumpster"

ENT.plant = true

ENT.models = {
	"models/llama/dumpster.mdl",
	"models/llama/dumpsteroff.mdl",
	"models/llama/dumpsteropen.mdl",
	"models/props_fallout/dumpster.mdl",
}

ENT.resources = {
	["j_25lb_weight"] = 1,
	["j_40lb_barweight"] = 1,
	["j_80lb_barweight"] = 1,
	["j_80lb_curlbar"] = 1,
	["j_160lb_barweight"] = 1,
	["j_abraxo"] = 1,
	["j_alarmclock"] = 1,
	["j_aluminumcan"] = 1,
	["j_ammobag"] = 1,
	["j_antifreeze"] = 1,
	["j_ashtray"] = 1,
	["j_babybottle"] = 1,
	["j_babyrattle"] = 1,
	["j_ball"] = 1,
	["j_baseball_glove"] = 1,
	["j_baseballbase"] = 1,
	["j_basketball"] = 1,
	["j_beaker1"] = 1,
	["j_beaker2"] = 1,
	["j_beaker3"] = 1,
	["j_beakerstand"] = 1,
	["j_bioscanner"] = 1,
	["j_blanket"] = 1,
	["j_boardgame"] = 1,
	["j_blowtorch"] = 1,
	["j_bonecutter"] = 1,
	["j_bonesaw"] = 1,
	["j_bowl"] = 1,
	["j_bowlingball"] = 1,
	["j_bowlingpin"] = 1,
	["j_brahmin_skull"] = 1,
	["j_breadbox"] = 1,
	["j_broom"] = 1,
	["j_bucket"] = 1,
	["j_bunsenburn"] = 1,
	["j_burgerbox"] = 1,
	["j_buttercupbody"] = 1,
	["j_buttercupfull"] = 1,
	["j_buttercupbleg"] = 1,
	["j_butterknife"] = 1,
	["j_cactus_plant"] = 1,
	["j_cafeteriatray"] = 1,
	["j_cakepan"] = 1,
	["j_camera"] = 1,
	["j_catbowl"] = 1,
	["j_chessboard"] = 1,
	["j_circuitboard"] = 1,
	["j_clipboard"] = 1,
	["j_clotheshanger"] = 1,
	["j_clothesiron"] = 1,
	["j_coffeecup"] = 1,
	["j_coffeepot"] = 1,
	["j_coffeetin"] = 1,
	["j_collander"] = 1,
	["j_coolant"] = 1,
	["j_cottonyarn"] = 1,
	["j_cuttingboard"] = 1,
	["j_decanter"] = 1,
	["j_dishrag"] = 1,
	["j_dogbowl"] = 1,
	["j_drinkglass"] = 1,
	["j_ducttapepack"] = 1,
	["j_earexaminer"] = 1,
	["j_enamelbucket"] = 1,
	["j_extinguisher"] = 1,
	["j_featherduster"] = 1,
	["j_fork"] = 1,
	["j_fryingpan"] = 1,
	["j_fuse"] = 1,
	["j_gascan"] = 1,
	["j_globe"] = 1,
	["j_gnome"] = 1,
	["j_hairbrush"] = 1,
	["j_hammer"] = 1,
	["j_highpowermagnet"] = 1,
	["j_hotdogbox"] = 1,
	["j_hotplate"] = 1,
	["j_industrialshort"] = 1,
	["j_injector"] = 1,
	["j_jangles"] = 1,
	["j_jug"] = 1,
	["j_kitchenscale"] = 1,
	["j_ladle"] = 1,
	["j_lamp"] = 1,
	["j_lamp2"] = 1,
	["j_lifepreserver"] = 1,
	["j_lightbulb"] = 1,
	["j_lighter"] = 1,
	["j_locket"] = 1,
	["j_lumberjacksaw"] = 1,
	["j_magnifyingglass"] = 1,
	["j_microscope"] = 1,
	["j_mop"] = 1,
	["j_mrhandyfuel"] = 1,
	["j_newspaper"] = 1,
	["j_nitrogendispenser"] = 1,
	["j_oilcan"] = 1,
	["j_oilcanister"] = 1,
	["j_ovenmitt"] = 1,
	["j_paintcan"] = 1,
	["j_paintbrush"] = 1,
	["j_pan"] = 1,
	["j_papercup"] = 1,
	["j_pen"] = 1,
	["j_phone"] = 1,
	["j_picture_frame"] = 1,
	["j_pillow"] = 1,
	["j_pitcher"] = 1,
	["j_pumpkin"] = 1,
	["j_plate"] = 1,
	["j_rib"] = 1,
	["j_saucepan"] = 1,
	["j_scalpel"] = 1,
	["j_scissors"] = 1,
	["j_screwdriver"] = 1,
	["j_sensormodule"] = 1,
	["j_shoppingbasket"] = 1,
	["j_shovel"] = 1,
	["j_skull"] = 1,
	["j_soap"] = 1,
	["j_spatula"] = 1,
	["j_spoon"] = 1,
	["j_surgicaltray"] = 1,
	["j_teddybear"] = 1,
	["j_testtuberack"] = 1,
	["j_tincan"] = 1,
	["j_toaster"] = 1,
	["j_tongs"] = 1,
	["j_toothbrush"] = 1,
	["j_toyalien"] = 1,
	["j_toyblock"] = 1,
	["j_toygutsy"] = 1,
	["j_toyprotectron"] = 1,
	["j_toysentrybot"] = 1,
	["j_toycar"] = 1,
	["j_toykit"] = 1,
	["j_toysoldier"] = 1,
	["j_toytruck"] = 1,
	["j_triflag"] = 1,
	["j_turpentine"] = 1,
	["j_typewriter"] = 1,
	["j_umbrella"] = 1,
	["j_vacuumtube"] = 1,
	["j_vase"] = 1,
	["j_watch"] = 1,
	["j_poolcue"] = 1,
	["j_wonderglue"] = 1,
	["j_wondergluelarge"] = 1,
	["j_teddybearfrimp"] = 1,
	

}

if (SERVER) then
	function ENT:Initialize()
		local model = self.models[math.random(#self.models)]
		self:SetModel(model)
		self:SetMaterial("models/prop/drop/iron_ore")
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self:SetHealth(150)
		
		local pos = self:GetPos()
		
		self:SetPos(Vector(pos.X,pos.Y,pos.Z + 15))
		self:SetAngles(Angle(0,math.random(0,360),0))
		
		self.gathers = math.random(7,9)
		
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(true)
			--physicsObject:Sleep()
		end
	end
	
	function ENT:OnTakeDamage( dmginfo )

	end	
end
