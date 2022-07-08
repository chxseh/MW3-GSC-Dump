
main()
{
self.animTree = "";
self.additionalAssets = "common_rambo_anims.csv";
self.team = "axis";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.12;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "usp";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 512.000000, 400.000000 );
self setEngagementMaxDist( 1024.000000, 1250.000000 );
}
switch( codescripts\character::get_random_weapon(3) )
{
case 0:
self.weapon = "pecheneg";
break;
case 1:
self.weapon = "pecheneg_acog";
break;
case 2:
self.weapon = "pecheneg_reflex";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_africa_militia_lmg_a::main();
break;
case 1:
character\character_africa_militia_lmg_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_lmg_a::precache();
character\character_africa_militia_lmg_b::precache();
precacheItem("pecheneg");
precacheItem("pecheneg_acog");
precacheItem("pecheneg_reflex");
precacheItem("usp");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_lmg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_lmg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
