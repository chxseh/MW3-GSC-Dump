
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
self.sidearm = "fnfiveseven";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(3) )
{
case 0:
self.weapon = "p90";
break;
case 1:
self.weapon = "p90_eotech";
break;
case 2:
self.weapon = "p90_reflex";
break;
}
switch( codescripts\character::get_random_character(8) )
{
case 0:
character\character_chemwar_russian_assault_b::main();
break;
case 1:
character\character_chemwar_russian_assault_c::main();
break;
case 2:
character\character_chemwar_russian_assault_d::main();
break;
case 3:
character\character_chemwar_russian_assault_e::main();
break;
case 4:
character\character_chemwar_russian_assault_bb::main();
break;
case 5:
character\character_chemwar_russian_assault_cc::main();
break;
case 6:
character\character_chemwar_russian_assault_dd::main();
break;
case 7:
character\character_chemwar_russian_assault_ee::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_chemwar_russian_assault_b::precache();
character\character_chemwar_russian_assault_c::precache();
character\character_chemwar_russian_assault_d::precache();
character\character_chemwar_russian_assault_e::precache();
character\character_chemwar_russian_assault_bb::precache();
character\character_chemwar_russian_assault_cc::precache();
character\character_chemwar_russian_assault_dd::precache();
character\character_chemwar_russian_assault_ee::precache();
precacheItem("p90");
precacheItem("p90_eotech");
precacheItem("p90_reflex");
precacheItem("fnfiveseven");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_d::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_e::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_bb::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_cc::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_dd::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_ee::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
