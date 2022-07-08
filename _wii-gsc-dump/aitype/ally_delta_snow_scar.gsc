
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
switch( codescripts\character::get_random_weapon(4) )
{
case 0:
self.weapon = "scar_h_acog";
break;
case 1:
self.weapon = "scar_h_reflex";
break;
case 2:
self.weapon = "scar_h_shotgun";
break;
case 3:
self.weapon = "scar_h_grenadier";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_delta_elite_snow_assault_aa::main();
break;
case 1:
character\character_delta_elite_snow_assault_ab::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_elite_snow_assault_aa::precache();
character\character_delta_elite_snow_assault_ab::precache();
precacheItem("scar_h_acog");
precacheItem("scar_h_reflex");
precacheItem("scar_h_shotgun");
precacheItem("scar_h_shotgun_attach");
precacheItem("scar_h_grenadier");
precacheItem("SCAR_H_M203");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_elite_snow_assault_aa::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_snow_assault_ab::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
