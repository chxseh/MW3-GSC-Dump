
main()
{
self setModel("body_pmc_africa_assault_a");
self attach("head_hero_yuri_a", "", true);
self.headModel = "head_hero_yuri_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_pmc_africa_assault_a");
precacheModel("head_hero_yuri_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_pmc_africa_assault_a";
models[models.size]="head_hero_yuri_a";
return models;
}
