
main()
{
self setModel("body_chemwar_russian_assault_b");
self attach("head_russian_military_a", "", true);
self.headModel = "head_russian_military_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_b");
precacheModel("head_russian_military_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_b";
models[models.size]="head_russian_military_a";
return models;
}
