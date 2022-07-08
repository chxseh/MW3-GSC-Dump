
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
self.weapon = "pp90m1";
break;
case 1:
self.weapon = "pp90m1_reflex";
break;
}
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_africa_militia_smg_a::main();
break;
case 1:
character\character_africa_militia_smg_b::main();
break;
case 2:
character\character_africa_militia_smg_c::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_smg_a::precache();
character\character_africa_militia_smg_b::precache();
character\character_africa_militia_smg_c::precache();
precacheItem("pp90m1");
precacheItem("pp90m1_reflex");
precacheItem("glock");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_smg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_smg_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_smg_c::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
