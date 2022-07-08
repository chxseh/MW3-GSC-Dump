
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "beretta";
self.sidearm = "beretta";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "m16_basic";
character\character_tank_crew_loader::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_tank_crew_loader::precache();
precacheItem("m16_basic");
precacheItem("beretta");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_tank_crew_loader::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
