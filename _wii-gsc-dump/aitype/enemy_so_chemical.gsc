
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
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "none";
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_chemwar_russian_assault_a_s::main();
break;
case 1:
character\character_chemwar_russian_assault_aa_s::main();
break;
case 2:
character\character_chemwar_m_d_so_s::main();
break;
case 3:
character\character_chemwar_m_dd_so_s::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_chemwar_russian_assault_a_s::precache();
character\character_chemwar_russian_assault_aa_s::precache();
character\character_chemwar_m_d_so_s::precache();
character\character_chemwar_m_dd_so_s::precache();
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_a_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_russian_assault_aa_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_m_d_so_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_chemwar_m_dd_so_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
