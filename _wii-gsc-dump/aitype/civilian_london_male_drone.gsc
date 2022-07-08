
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
character\character_civilian_london_male_a_drone::main();
break;
case 1:
character\character_civilian_london_male_b_drone::main();
break;
case 2:
character\character_civilian_london_male_c_drone::main();
break;
}
}
spawner()
{
self setspawnerteam("neutral");
}
precache()
{
character\character_civilian_london_male_a_drone::precache();
character\character_civilian_london_male_b_drone::precache();
character\character_civilian_london_male_c_drone::precache();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_civilian_london_male_a_drone::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_london_male_b_drone::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_london_male_c_drone::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
