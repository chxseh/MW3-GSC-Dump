
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
switch( codescripts\character::get_random_weapon(4) )
{
case 0:
self.weapon = "ak47";
break;
case 1:
self.weapon = "ak47_reflex";
break;
case 2:
self.weapon = "ak47_grenadier";
break;
case 3:
self.weapon = "ak47_acog";
break;
}
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_africa_militia_assault_a::main();
break;
case 1:
character\character_africa_militia_assault_b::main();
break;
case 2:
character\character_africa_militia_assault_c::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_assault_a::precache();
character\character_africa_militia_assault_b::precache();
character\character_africa_militia_assault_c::precache();
precacheItem("ak47");
precacheItem("ak47_reflex");
precacheItem("ak47_grenadier");
precacheItem("gl_ak47");
precacheItem("ak47_acog");
precacheItem("glock");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_assault_c::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
