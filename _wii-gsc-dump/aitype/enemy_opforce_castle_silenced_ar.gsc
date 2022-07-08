
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
switch( codescripts\character::get_random_weapon(5) )
{
case 0:
self.weapon = "ak47_silencer";
break;
case 1:
self.weapon = "ak47_silencer_reflex";
break;
case 2:
self.weapon = "ak47_silencer_acog";
break;
case 3:
self.weapon = "scar_h_silencer";
break;
case 4:
self.weapon = "g36c_silencer";
break;
}
switch( codescripts\character::get_random_character(4) )
{
case 0:
character\character_opforce_henchmen_assault_a::main();
break;
case 1:
character\character_opforce_henchmen_assault_b::main();
break;
case 2:
character\character_opforce_henchmen_lmg_a::main();
break;
case 3:
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
character\character_opforce_henchmen_assault_a::precache();
character\character_opforce_henchmen_assault_b::precache();
character\character_opforce_henchmen_lmg_a::precache();
character\character_opforce_henchmen_smg_b::precache();
precacheItem("ak47_silencer");
precacheItem("ak47_silencer_reflex");
precacheItem("ak47_silencer_acog");
precacheItem("scar_h_silencer");
precacheItem("g36c_silencer");
precacheItem("p99_tactical_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_assault_b::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_lmg_a::enumerate_xmodels());
models = codescripts\character::array_append(models,character\character_opforce_henchmen_smg_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
