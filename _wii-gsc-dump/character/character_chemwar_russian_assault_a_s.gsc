
main()
{
self setModel("body_chemwar_russian_assault_b_s");
self attach("head_chemwar_russian_d_s", "", true);
self.headModel = "head_chemwar_russian_d_s";
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_b_s");
precacheModel("head_chemwar_russian_d_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_b_s";
models[models.size]="head_chemwar_russian_d_s";
return models;
}
