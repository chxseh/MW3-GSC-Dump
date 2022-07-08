
main()
{
self.animTree = "";
self.additionalAssets = "common_rambo_anims.csv";
self.team = "axis";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.18;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 280.000000, 400.000000 );
}
self.weapon = "striker";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_africa_militia_shotgun_a::main();
break;
case 1:
character\character_africa_militia_shotgun_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_shotgun_a::precache();
character\character_africa_militia_shotgun_b::precache();
precacheItem("striker");
precacheItem("usp");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_shotgun_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_shotgun_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
