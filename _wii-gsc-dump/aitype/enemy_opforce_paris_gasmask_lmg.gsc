
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
self.sidearm = "p99";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 768.000000 );
}
switch( codescripts\character::get_random_weapon(3) )
{
case 0:
self.weapon = "pecheneg";
break;
case 1:
self.weapon = "pecheneg_reflex";
break;
case 2:
self.weapon = "pecheneg_acog";
break;
}
character\character_opforce_paris_gasmask::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_paris_gasmask::precache();
precacheItem("pecheneg");
precacheItem("pecheneg_reflex");
precacheItem("pecheneg_acog");
precacheItem("p99");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_paris_gasmask::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
