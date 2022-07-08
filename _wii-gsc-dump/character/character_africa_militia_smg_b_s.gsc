
main()
{
self setModel("body_africa_militia_assault_a_s");
self attach("head_africa_militia_a_hat_s", "", true);
self.headModel = "head_africa_militia_a_hat_s";
self.voice = "african";
}
precache()
{
precacheModel("body_africa_militia_assault_a_s");
precacheModel("head_africa_militia_a_hat_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_africa_militia_assault_a_s";
models[models.size]="head_africa_militia_a_hat_s";
return models;
}
