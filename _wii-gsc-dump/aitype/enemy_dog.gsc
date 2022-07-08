
main()
{
self.animTree = "dog.atr";
self.additionalAssets = "common_dogs.csv";
self.team = "axis";
self.type = "dog";
self.subclass = "regular";
self.accuracy = 0.2;
self.health = 200;
self.secondaryweapon = "dog_bite";
self.sidearm = "";
self.wiiOptimized = 0;
self.grenadeWeapon = "fraggrenade";
self.grenadeAmmo = 0;
if ( isAI( self ) )
{
self setEngagementMinDist( 256.000000, 0.000000 );
self setEngagementMaxDist( 768.000000, 1024.000000 );
}
self.weapon = "dog_bite";
character\character_sp_german_sheperd_dog_s::main();
}
spawner()
{
self setspawnerteam("axis");
}
precache()
{
character\character_sp_german_sheperd_dog_s::precache();
precacheItem("dog_bite");
precacheItem("dog_bite");
precacheItem("fraggrenade");
animscripts\dog\dog_init::initDogAnimations();
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,character\character_sp_german_sheperd_dog_s::enumerate_xmodels());
codescripts\character::call_enumerate_xmodel_callback( models );
}
