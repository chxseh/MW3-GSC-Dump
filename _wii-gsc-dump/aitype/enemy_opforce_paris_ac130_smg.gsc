
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
self.sidearm = "pp2000";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 768.000000 );
}
self.weapon = "ak47_ac130";
character\character_opforce_paris_smg::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_paris_smg::precache();
precacheItem("ak47_ac130");
precacheItem("pp2000");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_paris_smg::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
