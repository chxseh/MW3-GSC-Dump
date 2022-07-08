
main()
{
self setModel("africa_civ_male_burned");
self.voice = "african";
}
precache()
{
precacheModel("africa_civ_male_burned");
}
enumerate_xmodels()
{
models = [];
models[models.size]="africa_civ_male_burned";
return models;
}
