
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
switch( codescripts\character::get_random_character(6) )
{
case 0:
character\character_civilian_dubai_male_a::main();
break;
case 1:
character\character_civilian_dubai_male_a_alt::main();
break;
case 2:
character\character_civilian_dubai_male_b::main();
break;
case 3:
character\character_civilian_dubai_male_b_alt::main();
break;
case 4:
character\character_civilian_dubai_male_c::main();
break;
case 5:
character\character_civilian_dubai_male_c_alt::main();
break;
}
}
spawner()
{
self setspawnerteam("neutral");
}
precache()
{
character\character_civilian_dubai_male_a::precache();
character\character_civilian_dubai_male_a_alt::precache();
character\character_civilian_dubai_male_b::precache();
character\character_civilian_dubai_male_b_alt::precache();
character\character_civilian_dubai_male_c::precache();
character\character_civilian_dubai_male_c_alt::precache();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_a_alt::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_b_alt::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_c::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_civilian_dubai_male_c_alt::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
