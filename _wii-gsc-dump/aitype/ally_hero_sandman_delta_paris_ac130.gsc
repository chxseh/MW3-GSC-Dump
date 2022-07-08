
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
switch( codescripts\character::get_random_weapon(3) )
{
case 0:
self.weapon = "m16_basic";
break;
case 1:
self.weapon = "m16_acog";
break;
case 2:
self.weapon = "m16_grenadier";
break;
}
character\character_hero_delta_sandman::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_hero_delta_sandman::precache();
precacheItem("m16_basic");
precacheItem("m16_acog");
precacheItem("m16_grenadier");
precacheItem("m203");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_hero_delta_sandman::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
