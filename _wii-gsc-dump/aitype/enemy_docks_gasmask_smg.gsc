
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
switch( codescripts\character::get_random_weapon(6) )
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
case 3:
self.weapon = "pp90m1";
break;
case 4:
self.weapon = "pp90m1_eotech";
break;
case 5:
self.weapon = "pp90m1_reflex";
break;
}
switch( codescripts\character::get_random_character(10) )
{
case 0:
character\character_chemwar_russian_assault_a::main();
break;
case 1:
character\character_chemwar_russian_assault_m_b::main();
break;
case 2:
character\character_chemwar_russian_assault_m_c::main();
break;
case 3:
character\character_chemwar_russian_assault_m_d::main();
break;
case 4:
character\character_chemwar_russian_assault_m_e::main();
break;
case 5:
character\character_chemwar_russian_assault_aa::main();
break;
case 6:
character\character_chemwar_russian_assault_m_bb::main();
break;
case 7:
character\character_chemwar_russian_assault_m_cc::main();
break;
case 8:
character\character_chemwar_russian_assault_m_dd::main();
break;
case 9:
character\character_chemwar_russian_assault_m_ee::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_chemwar_russian_assault_a::precache();
character\character_chemwar_russian_assault_m_b::precache();
character\character_chemwar_russian_assault_m_c::precache();
character\character_chemwar_russian_assault_m_d::precache();
character\character_chemwar_russian_assault_m_e::precache();
character\character_chemwar_russian_assault_aa::precache();
character\character_chemwar_russian_assault_m_bb::precache();
character\character_chemwar_russian_assault_m_cc::precache();
character\character_chemwar_russian_assault_m_dd::precache();
character\character_chemwar_russian_assault_m_ee::precache();
precacheItem("p90");
precacheItem("p90_eotech");
precacheItem("p90_reflex");
precacheItem("pp90m1");
precacheItem("pp90m1_eotech");
precacheItem("pp90m1_reflex");
precacheItem("fnfiveseven");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_d::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_e::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_aa::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_bb::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_cc::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_dd::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_m_ee::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
