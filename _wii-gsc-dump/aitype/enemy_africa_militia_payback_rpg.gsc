
main()
{
self.animTree = "";
self.additionalAssets = "common_rambo_anims.csv";
self.team = "axis";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "ak47";
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 768.000000, 512.000000 );
self setEngagementMaxDist( 1024.000000, 1500.000000 );
}
self.weapon = "rpg";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_africa_militia_rpg_a::main();
break;
case 1:
character\character_africa_militia_rpg_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_rpg_a::precache();
character\character_africa_militia_rpg_b::precache();
precacheItem("rpg");
precacheItem("ak47");
precacheItem("usp");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_rpg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_rpg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
