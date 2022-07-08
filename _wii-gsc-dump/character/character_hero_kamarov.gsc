
main()
{
self setModel("body_russian_military_lmg_a");
self attach("head_hero_kamarov_a", "", true);
self.headModel = "head_hero_kamarov_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_lmg_a");
precacheModel("head_hero_kamarov_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_lmg_a";
models[models.size]="head_hero_kamarov_a";
return models;
}
