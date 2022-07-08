
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "glock";
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
self.weapon = "ak47";
break;
case 1:
self.weapon = "ak47_acog";
break;
case 2:
self.weapon = "g36c";
break;
case 3:
self.weapon = "g36c_reflex";
break;
}
character\character_opforce_prague_gasmask::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_prague_gasmask::precache();
precacheItem("ak47");
precacheItem("ak47_acog");
precacheItem("g36c");
precacheItem("g36c_reflex");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_prague_gasmask::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
