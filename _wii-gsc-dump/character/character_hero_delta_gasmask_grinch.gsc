
main()
{
self setModel("body_delta_elite_shotgun_a");
self attach("head_hero_grinch_gasmask_delta", "", true);
self.headModel = "head_hero_grinch_gasmask_delta";
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_shotgun_a");
precacheModel("head_hero_grinch_gasmask_delta");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_shotgun_a";
models[models.size]="head_hero_grinch_gasmask_delta";
return models;
}
