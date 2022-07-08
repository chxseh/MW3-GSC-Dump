
main()
{
self setModel("body_hero_sandman_seal_udt");
self attach("head_hero_sandman_seal_udt", "", true);
self.headModel = "head_hero_sandman_seal_udt";
self.voice = "delta";
}
precache()
{
precacheModel("body_hero_sandman_seal_udt");
precacheModel("head_hero_sandman_seal_udt");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_sandman_seal_udt";
models[models.size]="head_hero_sandman_seal_udt";
return models;
}
