
main()
{
self.animTree = "";
self.additionalAssets = "juggernaut_riotshield.csv";
self.team = "axis";
self.type = "human";
self.subclass = "riotshield";
self.accuracy = 0.2;
self.health = 3600;
self.secondaryweapon = "iw5_riotshield_so";
self.sidearm = "fnfiveseven";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 256.000000, 1024.000000 );
}
self.weapon = "pecheneg";
character\character_so_juggernaut_mid_s::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_so_juggernaut_mid_s::precache();
precacheItem("pecheneg");
precacheItem("iw5_riotshield_so");
precacheItem("fnfiveseven");
precacheItem("fraggrenade");
maps\_riotshield::init_riotshield(); maps\_juggernaut::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_so_juggernaut_mid_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
