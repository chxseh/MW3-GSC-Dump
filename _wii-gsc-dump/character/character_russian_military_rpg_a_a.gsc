
main()
{
self setModel("body_russian_military_rpg_a_airborne");
self attach("head_russian_military_a", "", true);
self.headModel = "head_russian_military_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_rpg_a_airborne");
precacheModel("head_russian_military_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_rpg_a_airborne";
models[models.size]="head_russian_military_a";
return models;
}
