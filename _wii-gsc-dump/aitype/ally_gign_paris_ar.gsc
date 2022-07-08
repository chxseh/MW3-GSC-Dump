
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
self.secondaryweapon = "coltanaconda";
self.sidearm = "coltanaconda";
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
self.weapon = "g36c";
break;
case 1:
self.weapon = "g36c_acog";
break;
case 2:
self.weapon = "g36c_grenadier";
break;
case 3:
self.weapon = "g36c_reflex";
break;
case 4:
self.weapon = "g36c_silencer";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_gign_paris_smg::main();
break;
case 1:
character\character_gign_paris_assault::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_gign_paris_smg::precache();
character\character_gign_paris_assault::precache();
precacheItem("g36c");
precacheItem("g36c_acog");
precacheItem("g36c_grenadier");
precacheItem("gl_g36c");
precacheItem("g36c_reflex");
precacheItem("g36c_silencer");
precacheItem("coltanaconda");
precacheItem("coltanaconda");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_gign_paris_smg::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_gign_paris_assault::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
