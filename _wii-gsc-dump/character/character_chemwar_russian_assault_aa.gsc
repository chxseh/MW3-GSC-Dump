
main()
{
self setModel("body_chemwar_russian_assault_bb");
self attach("head_chemwar_russian_d", "", true);
self.headModel = "head_chemwar_russian_d";
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_bb");
precacheModel("head_chemwar_russian_d");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_bb";
models[models.size]="head_chemwar_russian_d";
return models;
}
