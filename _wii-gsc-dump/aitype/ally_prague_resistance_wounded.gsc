
main()
{
self.animTree = "";
self.additionalAssets = "common_rambo_anims.csv";
self.team = "allies";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.12;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "glock";
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
self.weapon = "ak47";
break;
case 1:
self.weapon = "ak74u";
break;
}
character\character_prague_males_unarmed::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_prague_males_unarmed::precache();
precacheItem("ak47");
precacheItem("ak74u");
precacheItem("glock");
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_prague_males_unarmed::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
