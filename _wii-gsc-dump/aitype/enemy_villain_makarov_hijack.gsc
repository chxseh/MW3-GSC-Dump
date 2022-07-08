
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
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "fnfiveseven";
character\character_vil_makarov_hijack::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_vil_makarov_hijack::precache();
precacheItem("fnfiveseven");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_vil_makarov_hijack::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
