
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "riotshield";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "iw5_riotshield_so";
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
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_gign_paris_smg_s::main();
break;
case 1:
character\character_gign_paris_assault_s::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_gign_paris_smg_s::precache();
character\character_gign_paris_assault_s::precache();
precacheItem("iw5_riotshield_so");
maps\_riotshield::init_riotshield();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_gign_paris_smg_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_gign_paris_assault_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
