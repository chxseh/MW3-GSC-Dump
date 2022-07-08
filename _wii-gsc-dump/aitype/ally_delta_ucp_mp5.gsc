
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
self.sidearm = "beretta";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "mp5";
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_delta_urban_smg_a::main();
break;
case 1:
character\character_delta_urban_smg_b::main();
break;
case 2:
character\character_delta_urban_smg_c::main();
break;
}
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_delta_urban_smg_a::precache();
character\character_delta_urban_smg_b::precache();
character\character_delta_urban_smg_c::precache();
precacheItem("mp5");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_delta_urban_smg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_urban_smg_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_delta_urban_smg_c::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
