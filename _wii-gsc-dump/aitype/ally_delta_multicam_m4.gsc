
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "";
self.sidearm = "usp_silencer";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(2) )
{
case 0:
self.weapon = "m4_grunt";
break;
case 1:
self.weapon = "m4_grenadier";
break;
}
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_delta_elite_assault_aa::main();
break;
case 1:
character\character_delta_elite_assault_ab::main();
break;
case 2:
character\character_delta_elite_assault_ba::main();
break;
case 3:
character\character_delta_elite_assault_bb::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_elite_assault_aa::precache();
character\character_delta_elite_assault_ab::precache();
character\character_delta_elite_assault_ba::precache();
character\character_delta_elite_assault_bb::precache();
precacheItem("m4_grunt");
precacheItem("m4_grenadier");
precacheItem("m203_m4");
precacheItem("usp_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_elite_assault_aa::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_ab::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_ba::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_bb::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
