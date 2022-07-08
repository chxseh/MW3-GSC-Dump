
main()
{
self setModel("body_airborne_assault_b");
self attach("head_airborne_a", "", true);
self.headModel = "head_airborne_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_airborne_assault_b");
precacheModel("head_airborne_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_airborne_assault_b";
models[models.size]="head_airborne_a";
return models;
}
