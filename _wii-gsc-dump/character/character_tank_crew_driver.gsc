
main()
{
self setModel("body_tank_crew_a");
self attach("head_tank_a", "", true);
self.headModel = "head_tank_a";
self.voice = "american";
}
precache()
{
precacheModel("body_tank_crew_a");
precacheModel("head_tank_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_tank_crew_a";
models[models.size]="head_tank_a";
return models;
}
