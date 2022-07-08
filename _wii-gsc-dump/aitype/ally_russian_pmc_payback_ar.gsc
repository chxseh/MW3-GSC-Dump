
main()
{
self.animTree = "";
self.additionalAssets = "";
self.team = "allies";
self.type = "human";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "usp";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
switch( codescripts\character::get_random_weapon(6) )
{
case 0:
self.weapon = "ak47";
break;
case 1:
self.weapon = "ak47_acog";
break;
case 2:
self.weapon = "ak47_eotech";
break;
case 3:
self.weapon = "ak47_reflex";
break;
case 4:
self.weapon = "m4_grunt";
break;
case 5:
self.weapon = "m4_grenadier";
break;
}
character\character_pmc_africa_assault_a::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_pmc_africa_assault_a::precache();
precacheItem("ak47");
precacheItem("ak47_acog");
precacheItem("ak47_eotech");
precacheItem("ak47_reflex");
precacheItem("m4_grunt");
precacheItem("m4_grenadier");
precacheItem("m203_m4");
precacheItem("usp");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_pmc_africa_assault_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
