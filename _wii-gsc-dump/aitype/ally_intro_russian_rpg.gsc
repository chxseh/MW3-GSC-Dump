
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "ak47";
self.sidearm = "mp412";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "rpg";
character\character_pmc_africa_smg_a::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_pmc_africa_smg_a::precache();
precacheItem("rpg");
precacheItem("ak47");
precacheItem("mp412");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_pmc_africa_smg_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
