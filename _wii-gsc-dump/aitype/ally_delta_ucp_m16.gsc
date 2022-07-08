
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
self.sidearm = "beretta";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(3) )
{
case 0:
self.weapon = "m16_basic";
break;
case 1:
self.weapon = "m16_acog";
break;
case 2:
self.weapon = "m16_grenadier";
break;
}
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_delta_urban_assault_a::main();
break;
case 1:
character\character_delta_urban_assault_b::main();
break;
case 2:
character\character_delta_urban_assault_c::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_urban_assault_a::precache();
character\character_delta_urban_assault_b::precache();
character\character_delta_urban_assault_c::precache();
precacheItem("m16_basic");
precacheItem("m16_acog");
precacheItem("m16_grenadier");
precacheItem("m203");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_urban_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_urban_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_urban_assault_c::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
