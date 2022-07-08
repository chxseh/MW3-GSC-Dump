
main()
{
self.animTree = "";
self.additionalAssets = "rpg_player.csv";
self.team = "allies";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.12;
self.health = 150;
self.secondaryweapon = "ak74u";
self.sidearm = "glock";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "rpg";
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_prague_civilian_male_c::main();
break;
case 1:
character\character_prague_civilian_male_e::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_prague_civilian_male_c::precache();
character\character_prague_civilian_male_e::precache();
precacheItem("rpg");
precacheItem("ak74u");
precacheItem("glock");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_prague_civilian_male_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_prague_civilian_male_e::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
