
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "neutral";
self.type = "civilian";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 30;
self.secondaryweapon = "";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "none";
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_prague_civilian_fem_drone_a::main();
break;
case 1:
character\character_prague_civilian_fem_drone_c::main();
break;
case 2:
character\character_prague_civilian_fem_drone_d::main();
break;
}
}
spawner()
{
self setspawnerteam("neutral");
}
precache()
{
character\character_prague_civilian_fem_drone_a::precache();
character\character_prague_civilian_fem_drone_c::precache();
character\character_prague_civilian_fem_drone_d::precache();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_prague_civilian_fem_drone_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_prague_civilian_fem_drone_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_prague_civilian_fem_drone_d::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
