
main()
{
self setModel("body_russian_military_assault_a_arctic");
self attach("head_russian_military_a", "", true);
self.headModel = "head_russian_military_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_a_arctic");
precacheModel("head_russian_military_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_a_arctic";
models[models.size]="head_russian_military_a";
return models;
}
