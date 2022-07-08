
main()
{
self setModel("body_hero_sandman_seal_udt_b");
self attach("head_hero_sandman_seal_udt_b", "", true);
self.headModel = "head_hero_sandman_seal_udt_b";
self.voice = "delta";
}
precache()
{
precacheModel("body_hero_sandman_seal_udt_b");
precacheModel("head_hero_sandman_seal_udt_b");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_sandman_seal_udt_b";
models[models.size]="head_hero_sandman_seal_udt_b";
return models;
}
