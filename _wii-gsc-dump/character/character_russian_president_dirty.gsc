
main()
{
self setModel("body_russian_president_dirty");
self attach("head_russian_president_dirty", "", true);
self.headModel = "head_russian_president_dirty";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_president_dirty");
precacheModel("head_russian_president_dirty");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_president_dirty";
models[models.size]="head_russian_president_dirty";
return models;
}
