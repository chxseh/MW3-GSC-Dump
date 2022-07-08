
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "usp_silencer";
self.sidearm = "usp_silencer";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "mk46_grip";
character\character_sp_juggernaut_dubai_nogear::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_sp_juggernaut_dubai_nogear::precache();
precacheItem("mk46_grip");
precacheItem("usp_silencer");
precacheItem("usp_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_sp_juggernaut_dubai_nogear::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
