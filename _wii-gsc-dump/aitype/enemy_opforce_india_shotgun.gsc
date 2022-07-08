
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
self.sidearm = "mp412";
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
self.weapon = "spas12";
break;
case 1:
self.weapon = "spas12_eotech";
break;
case 2:
self.weapon = "spas12_grip";
break;
case 3:
self.weapon = "spas12_reflex";
break;
}
character\character_russian_military_shgn_a_b::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_russian_military_shgn_a_b::precache();
precacheItem("spas12");
precacheItem("spas12_eotech");
precacheItem("spas12_grip");
precacheItem("spas12_reflex");
precacheItem("mp412");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_russian_military_shgn_a_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
