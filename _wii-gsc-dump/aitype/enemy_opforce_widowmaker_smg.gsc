
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.25;
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
switch( codescripts\character::get_random_weapon(4) )
{
case 0:
self.weapon = "p90";
break;
case 1:
self.weapon = "p90_eotech";
break;
case 2:
self.weapon = "pp90m1";
break;
case 3:
self.weapon = "pp90m1_reflex";
break;
}
character\character_russian_naval_assault::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_russian_naval_assault::precache();
precacheItem("p90");
precacheItem("p90_eotech");
precacheItem("pp90m1");
precacheItem("pp90m1_reflex");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_russian_naval_assault::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
