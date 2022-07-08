
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
self.weapon = "rsass_hybrid_silenced";
character\character_hero_europe_soap_injured::main();
}
spawner()
{
self setspawnerteam("allies");
}
precache()
{
character\character_hero_europe_soap_injured::precache();
precacheItem("rsass_hybrid_silenced");
precacheItem("rsass_hybrid_reflex_silenced");
precacheItem("usp_silencer");
precacheItem("fraggrenade");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_hero_europe_soap_injured::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
