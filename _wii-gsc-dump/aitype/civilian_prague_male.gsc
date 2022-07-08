
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "neutral";
self.type = "civilian";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 30;
self.secondaryweapon = "";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "none";
character\character_prague_males_unarmed::main();
}
spawner()
{
self setspawnerteam("neutral");
}
precache()
{
character\character_prague_males_unarmed::precache();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_prague_males_unarmed::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
