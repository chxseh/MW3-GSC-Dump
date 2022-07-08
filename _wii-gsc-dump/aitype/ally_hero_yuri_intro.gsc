
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
self.weapon = "m4_grunt";
character\character_sp_russian_loyalist_d::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_sp_russian_loyalist_d::precache();
precacheItem("m4_grunt");
precacheItem("deserteagle");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_sp_russian_loyalist_d::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
