
main()
{
self setModel("body_africa_militia_assault_b");
self attach("head_africa_militia_a_hat", "", true);
self.headModel = "head_africa_militia_a_hat";
self.voice = "african";
}
precache()
{
precacheModel("body_africa_militia_assault_b");
precacheModel("head_africa_militia_a_hat");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_africa_militia_assault_b";
models[models.size]="head_africa_militia_a_hat";
return models;
}
