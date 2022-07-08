
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "glock";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(9) )
{
case 0:
self.weapon = "ak47";
break;
case 1:
self.weapon = "ak47_reflex";
break;
case 2:
self.weapon = "ak47_eotech";
break;
case 3:
self.weapon = "ak47_acog";
break;
case 4:
self.weapon = "scar_h";
break;
case 5:
self.weapon = "scar_h_acog";
break;
case 6:
self.weapon = "g36c_acog";
break;
case 7:
self.weapon = "g36c_reflex";
break;
case 8:
self.weapon = "g36c";
break;
}
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_opforce_henchmen_assault_a::main();
break;
case 1:
character\character_opforce_henchmen_assault_b::main();
break;
case 2:
character\character_opforce_henchmen_lmg_b::main();
break;
case 3:
character\character_opforce_henchmen_smg_a::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_assault_a::precache();
character\character_opforce_henchmen_assault_b::precache();
character\character_opforce_henchmen_lmg_b::precache();
character\character_opforce_henchmen_smg_a::precache();
precacheItem("ak47");
precacheItem("ak47_reflex");
precacheItem("ak47_eotech");
precacheItem("ak47_acog");
precacheItem("scar_h");
precacheItem("scar_h_acog");
precacheItem("g36c_acog");
precacheItem("g36c_reflex");
precacheItem("g36c");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_lmg_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
