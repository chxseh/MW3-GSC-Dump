
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 100;
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
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_delta_elite_assault_aa_s::main();
break;
case 1:
character\character_delta_elite_assault_ab_s::main();
break;
case 2:
character\character_delta_elite_assault_ba_s::main();
break;
case 3:
character\character_delta_elite_assault_bb_s::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_elite_assault_aa_s::precache();
character\character_delta_elite_assault_ab_s::precache();
character\character_delta_elite_assault_ba_s::precache();
character\character_delta_elite_assault_bb_s::precache();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_elite_assault_aa_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_ab_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_ba_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_elite_assault_bb_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
