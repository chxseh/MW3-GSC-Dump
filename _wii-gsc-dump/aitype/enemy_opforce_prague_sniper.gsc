
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.7;
self.health = 150;
self.secondaryweapon = "ak47";
self.sidearm = "glock";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 2048.000000, 4096.000000 );
}
self.weapon = "rsass";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_prague_assault_a::main();
break;
case 1:
character\character_opforce_prague_assault_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_prague_assault_a::precache();
character\character_opforce_prague_assault_b::precache();
precacheItem("rsass");
precacheItem("ak47");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_prague_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_prague_assault_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
