
main()
{
self setModel("body_russian_navy_sleevesdown");
self attach("head_russian_navy_b", "", true);
self.headModel = "head_russian_navy_b";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_navy_sleevesdown");
precacheModel("head_russian_navy_b");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_navy_sleevesdown";
models[models.size]="head_russian_navy_b";
return models;
}
