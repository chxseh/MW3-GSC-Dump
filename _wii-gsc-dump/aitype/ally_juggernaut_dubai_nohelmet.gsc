
main()
{
self.animTree = "";
self.additionalAssets = "juggernaut.csv";
self.team = "allies";
self.type = "human";
self.subclass = "juggernaut";
self.accuracy = 0.2;
self.health = 3600;
self.secondaryweapon = "deserteagle";
self.sidearm = "deserteagle";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 256.000000, 1024.000000 );
}
self.weapon = "mk46";
character\character_sp_juggernaut_dubai_nohelmet::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_sp_juggernaut_dubai_nohelmet::precache();
precacheItem("mk46");
precacheItem("deserteagle");
precacheItem("deserteagle");
precacheItem("fraggrenade");
maps\_juggernaut::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_sp_juggernaut_dubai_nohelmet::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
