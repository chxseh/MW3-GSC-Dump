
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "civilian";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "ak47";
character\character_russian_pres_daughter_iw::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_russian_pres_daughter_iw::precache();
precacheItem("ak47");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_russian_pres_daughter_iw::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
