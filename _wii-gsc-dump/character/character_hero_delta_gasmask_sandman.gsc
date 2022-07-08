
main()
{
self setModel("body_hero_sandman_delta");
self attach("head_hero_sandman_gasmask", "", true);
self.headModel = "head_hero_sandman_gasmask";
self.voice = "delta";
}
precache()
{
precacheModel("body_hero_sandman_delta");
precacheModel("head_hero_sandman_gasmask");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_sandman_delta";
models[models.size]="head_hero_sandman_gasmask";
return models;
}
