
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
self.sidearm = "coltanaconda";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(4) )
{
case 0:
self.weapon = "mk46";
break;
case 1:
self.weapon = "mk46_acog";
break;
case 2:
self.weapon = "mk46_grip";
break;
case 3:
self.weapon = "mk46_reflex";
break;
}
character\character_gign_paris_lmg::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_gign_paris_lmg::precache();
precacheItem("mk46");
precacheItem("mk46_acog");
precacheItem("mk46_grip");
precacheItem("mk46_reflex");
precacheItem("coltanaconda");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_gign_paris_lmg::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
