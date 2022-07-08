
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
switch( codescripts\character::get_random_weapon(2) )
{
case 0:
self.weapon = "striker";
break;
case 1:
self.weapon = "striker_reflex";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_prague_shgn_a::main();
break;
case 1:
character\character_opforce_prague_shgn_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_prague_shgn_a::precache();
character\character_opforce_prague_shgn_b::precache();
precacheItem("striker");
precacheItem("striker_reflex");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_prague_shgn_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_prague_shgn_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
