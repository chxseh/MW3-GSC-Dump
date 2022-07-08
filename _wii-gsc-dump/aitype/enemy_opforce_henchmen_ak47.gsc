
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
self.weapon = "ak47";
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_opforce_henchmen_assault_a::main();
break;
case 1:
character\character_opforce_henchmen_assault_b::main();
break;
case 2:
character\character_opforce_henchmen_assault_c::main();
break;
case 3:
character\character_opforce_henchmen_assault_d::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_assault_a::precache();
character\character_opforce_henchmen_assault_b::precache();
character\character_opforce_henchmen_assault_c::precache();
character\character_opforce_henchmen_assault_d::precache();
precacheItem("ak47");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_d::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
