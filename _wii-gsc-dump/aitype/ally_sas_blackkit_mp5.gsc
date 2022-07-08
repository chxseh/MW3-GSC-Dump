
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
self.weapon = "mp5_eotech";
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_sas_urban_assault::main();
break;
case 1:
character\character_sas_urban_smg::main();
break;
case 2:
character\character_sas_urban_shotgun::main();
break;
case 3:
character\character_sas_urban_lmg::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_sas_urban_assault::precache();
character\character_sas_urban_smg::precache();
character\character_sas_urban_shotgun::precache();
character\character_sas_urban_lmg::precache();
precacheItem("mp5_eotech");
precacheItem("usp");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_sas_urban_assault::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_sas_urban_smg::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_sas_urban_shotgun::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_sas_urban_lmg::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
