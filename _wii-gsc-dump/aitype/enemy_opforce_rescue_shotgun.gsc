
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
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 280.000000, 400.000000 );
}
self.weapon = "spas12";
character\character_opforce_rescue_shgn_a::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_rescue_shgn_a::precache();
precacheItem("spas12");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_rescue_shgn_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
