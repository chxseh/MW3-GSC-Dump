
main()
{
self setModel("body_russian_military_assault_a");
self attach("head_russian_military_a", "", true);
self.headModel = "head_russian_military_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_a");
precacheModel("head_russian_military_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_a";
models[models.size]="head_russian_military_a";
return models;
}
