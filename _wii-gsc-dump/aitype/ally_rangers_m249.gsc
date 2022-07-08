
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
self.weapon = "m240";
break;
case 1:
self.weapon = "m240_acog";
break;
case 2:
self.weapon = "m240_reflex";
break;
}
character\character_rangers_bdu_assault_a::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_rangers_bdu_assault_a::precache();
precacheItem("m240");
precacheItem("m240_acog");
precacheItem("m240_reflex");
precacheItem("beretta");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_rangers_bdu_assault_a::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
