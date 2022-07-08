
main()
{
self setModel("body_russian_navy_coat");
self attach("head_russian_navy_c", "", true);
self.headModel = "head_russian_navy_c";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_navy_coat");
precacheModel("head_russian_navy_c");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_navy_coat";
models[models.size]="head_russian_navy_c";
return models;
}
