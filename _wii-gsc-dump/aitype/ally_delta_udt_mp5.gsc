
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
self.sidearm = "deserteagle";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "mp5_silencer_reflex_harbor";
character\character_delta_udt::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_udt::precache();
precacheItem("mp5_silencer_reflex_harbor");
precacheItem("deserteagle");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_udt::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
