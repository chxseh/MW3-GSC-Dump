
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
switch( codescripts\character::get_random_weapon(7) )
{
case 0:
self.weapon = "p90";
break;
case 1:
self.weapon = "p90_acog";
break;
case 2:
self.weapon = "p90_reflex";
break;
case 3:
self.weapon = "p90_eotech";
break;
case 4:
self.weapon = "pp90m1_reflex";
break;
case 5:
self.weapon = "pp90m1";
break;
case 6:
self.weapon = "pp90m1_acog";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_henchmen_smg_a::main();
break;
case 1:
character\character_opforce_henchmen_smg_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_smg_a::precache();
character\character_opforce_henchmen_smg_b::precache();
precacheItem("p90");
precacheItem("p90_acog");
precacheItem("p90_reflex");
precacheItem("p90_eotech");
precacheItem("pp90m1_reflex");
precacheItem("pp90m1");
precacheItem("pp90m1_acog");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
