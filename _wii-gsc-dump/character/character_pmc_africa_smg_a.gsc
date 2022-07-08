
main()
{
self setModel("body_pmc_africa_assault_a");
self attach("head_pmc_africa_a", "", true);
self.headModel = "head_pmc_africa_a";
self.voice = "pmc";
}
precache()
{
precacheModel("body_pmc_africa_assault_a");
precacheModel("head_pmc_africa_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_pmc_africa_assault_a";
models[models.size]="head_pmc_africa_a";
return models;
}
