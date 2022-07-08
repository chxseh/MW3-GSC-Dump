
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "";
self.sidearm = "fnfiveseven";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(5) )
{
case 0:
self.weapon = "mp5";
break;
case 1:
self.weapon = "mp5_eotech";
break;
case 2:
self.weapon = "mp5_reflex";
break;
case 3:
self.weapon = "mp5_silencer";
break;
case 4:
self.weapon = "mp5_silencer_reflex";
break;
}
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
precacheItem("mp5");
precacheItem("mp5_eotech");
precacheItem("mp5_reflex");
precacheItem("mp5_silencer");
precacheItem("mp5_silencer_reflex");
precacheItem("fnfiveseven");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_gign_paris_gasmask_smg::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_gign_paris_gasmask_assault::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
