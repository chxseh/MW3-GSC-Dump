
main()
{
self setModel("body_russian_navy_sleevesrolled");
self attach("head_russian_navy_a", "", true);
self.headModel = "head_russian_navy_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_navy_sleevesrolled");
precacheModel("head_russian_navy_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_navy_sleevesrolled";
models[models.size]="head_russian_navy_a";
return models;
}
