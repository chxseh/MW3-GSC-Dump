
main()
{
self setModel("body_delta_elite_snow_assault_aa");
self attach("head_hero_truck_headgear", "", true);
self.headModel = "head_hero_truck_headgear";
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_snow_assault_aa");
precacheModel("head_hero_truck_headgear");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_snow_assault_aa";
models[models.size]="head_hero_truck_headgear";
return models;
}
