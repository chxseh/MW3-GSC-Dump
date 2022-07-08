
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
self.sidearm = "pp2000";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "ak47_ac130";
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_opforce_paris_assault_a::main();
break;
case 1:
character\character_opforce_paris_assault_b::main();
break;
case 2:
character\character_russian_military_rpg_a_a::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_paris_assault_a::precache();
character\character_opforce_paris_assault_b::precache();
character\character_russian_military_rpg_a_a::precache();
precacheItem("ak47_ac130");
precacheItem("pp2000");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_paris_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_paris_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_russian_military_rpg_a_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
