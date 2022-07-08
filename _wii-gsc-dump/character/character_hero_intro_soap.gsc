
main()
{
self setModel("body_hero_soap_wounded");
self attach("head_hero_soap", "", true);
self.headModel = "head_hero_soap";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_hero_soap_wounded");
precacheModel("head_hero_soap");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_hero_soap_wounded";
models[models.size]="head_hero_soap";
return models;
}
