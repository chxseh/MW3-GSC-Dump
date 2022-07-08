
main()
{
self setModel("body_chemwar_russian_assault_bb");
self attach("head_russian_military_a", "", true);
self.headModel = "head_russian_military_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_bb");
precacheModel("head_russian_military_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_bb";
models[models.size]="head_russian_military_a";
return models;
}
