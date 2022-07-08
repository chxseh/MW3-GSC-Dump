
main()
{
self.animTree = "";
self.additionalAssets = "common_rambo_anims.csv";
self.team = "axis";
self.type = "human";
self.subclass = "militia";
self.accuracy = 0.2;
self.health = 150;
self.secondaryweapon = "";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 0.000000, 0.000000 );
self setEngagementMaxDist( 350.000000, 600.000000 );
}
self.weapon = "none";
character\character_so_russian_naval_assault_s::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_so_russian_naval_assault_s::precache();
precacheItem("fraggrenade");
maps\_rambo::main();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_so_russian_naval_assault_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
