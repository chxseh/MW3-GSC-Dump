
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
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 128.000000, 0.000000 );
self setEngagementMaxDist( 512.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(2) )
{
case 0:
self.weapon = "pecheneg_reflex";
break;
case 1:
self.weapon = "pecheneg";
break;
}
character\character_opforce_rescue_lmg_a::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_rescue_lmg_a::precache();
precacheItem("pecheneg_reflex");
precacheItem("pecheneg");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_rescue_lmg_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
