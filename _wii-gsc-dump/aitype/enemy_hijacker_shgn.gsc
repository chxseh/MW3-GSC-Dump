
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "axis";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.18;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "fnfiveseven";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 140.000000, 200.000000 );
}
self.weapon = "aa12";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_henchmen_shgn_a::main();
break;
case 1:
character\character_opforce_henchmen_shgn_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_shgn_a::precache();
character\character_opforce_henchmen_shgn_b::precache();
precacheItem("aa12");
precacheItem("fnfiveseven");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_shgn_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_shgn_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
