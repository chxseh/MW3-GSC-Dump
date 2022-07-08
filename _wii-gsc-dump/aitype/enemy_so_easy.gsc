
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
switch( codescripts\character::get_random_character(3) )
{
case 0:
character\character_africa_militia_smg_a_s::main();
break;
case 1:
character\character_africa_militia_smg_b_s::main();
break;
case 2:
character\character_africa_militia_smg_c_s::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_africa_militia_smg_a_s::precache();
character\character_africa_militia_smg_b_s::precache();
character\character_africa_militia_smg_c_s::precache();
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_africa_militia_smg_a_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_smg_b_s::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_africa_militia_smg_c_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
