
main()
{
self setModel("body_chemwar_russian_assault_b");
self attach("head_chemwar_russian_d", "", true);
self.headModel = "head_chemwar_russian_d";
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_b");
precacheModel("head_chemwar_russian_d");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_b";
models[models.size]="head_chemwar_russian_d";
return models;
}
