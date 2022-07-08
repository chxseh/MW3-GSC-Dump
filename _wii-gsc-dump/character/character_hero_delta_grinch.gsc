
main()
{
self setModel("body_hero_sandman_delta");
self attach("head_hero_grinch_delta", "", true);
self.headModel = "head_hero_grinch_delta";
self.voice = "delta";
}
precache()
{
precacheModel("body_hero_sandman_delta");
precacheModel("head_hero_grinch_delta");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_sandman_delta";
models[models.size]="head_hero_grinch_delta";
return models;
}
