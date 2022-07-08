
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
self.sidearm = "p99_tactical_silencer";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(2) )
{
case 0:
self.weapon = "p90_silencer";
break;
case 1:
self.weapon = "pp90m1_silencer";
break;
}
switch( codescripts\character::get_random_character(2) )
{
case 0:
character\character_opforce_henchmen_smg_a::main();
break;
case 1:
character\character_opforce_henchmen_smg_b::main();
break;
}
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_opforce_henchmen_smg_a::precache();
character\character_opforce_henchmen_smg_b::precache();
precacheItem("p90_silencer");
precacheItem("pp90m1_silencer");
precacheItem("p99_tactical_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
