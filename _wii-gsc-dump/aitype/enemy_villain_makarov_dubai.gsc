
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "deserteagle";
character\character_vil_makarov_finale::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_vil_makarov_finale::precache();
precacheItem("deserteagle");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_vil_makarov_finale::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
