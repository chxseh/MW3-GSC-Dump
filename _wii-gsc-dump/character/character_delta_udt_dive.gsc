
main()
{
self setModel("body_hero_sandman_seal_udt");
self attach("head_seal_udt_e_iw5", "", true);
self.headModel = "head_seal_udt_e_iw5";
self.voice = "delta";
}
precache()
{
precacheModel("body_hero_sandman_seal_udt");
precacheModel("head_seal_udt_e_iw5");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_sandman_seal_udt";
models[models.size]="head_seal_udt_e_iw5";
return models;
}
