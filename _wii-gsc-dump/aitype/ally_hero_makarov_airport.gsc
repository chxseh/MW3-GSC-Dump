
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 3600;
self.secondaryweapon = "m79";
self.sidearm = "beretta";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 4;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "m4_grunt";
character\character_vil_makarov::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_vil_makarov::precache();
precacheItem("m4_grunt");
precacheItem("m79");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_vil_makarov::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
