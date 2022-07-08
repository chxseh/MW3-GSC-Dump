
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "usp";
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "mp5_silencer";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_gign_paris_gasmask_smg::main();
break;
case 1:
character\character_gign_paris_gasmask_assault::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_gign_paris_gasmask_smg::precache();
character\character_gign_paris_gasmask_assault::precache();
precacheItem("mp5_silencer");
precacheItem("usp");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_gign_paris_gasmask_smg::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_gign_paris_gasmask_assault::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
