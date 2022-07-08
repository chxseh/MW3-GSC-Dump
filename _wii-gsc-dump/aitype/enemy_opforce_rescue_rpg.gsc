
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "ak47_arctic";
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 1024.000000 );
}
self.weapon = "rpg";
character\character_opforce_rescue_rpg::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_rescue_rpg::precache();
precacheItem("rpg");
precacheItem("ak47_arctic");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_rescue_rpg::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
