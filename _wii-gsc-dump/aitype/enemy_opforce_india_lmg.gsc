
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
self.sidearm = "mp412";
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
self.weapon = "pecheneg";
break;
case 1:
self.weapon = "mg36";
break;
}
character\character_russian_military_lmg_a_b::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_russian_military_lmg_a_b::precache();
precacheItem("pecheneg");
precacheItem("mg36");
precacheItem("mp412");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_russian_military_lmg_a_b::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
