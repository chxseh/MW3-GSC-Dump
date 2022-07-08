
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
self.sidearm = "usp_silencer";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "m21_scoped_cloth_silenced";
character\character_hero_africa_price::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_hero_africa_price::precache();
precacheItem("m21_scoped_cloth_silenced");
precacheItem("usp_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_hero_africa_price::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
