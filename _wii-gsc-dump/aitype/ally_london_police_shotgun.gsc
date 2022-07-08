
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
self.sidearm = "glock";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 768.000000 );
}
self.weapon = "spas12";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_london_police_a::main();
break;
case 1:
character\character_london_police_b::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_london_police_a::precache();
character\character_london_police_b::precache();
precacheItem("spas12");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_london_police_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_london_police_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
