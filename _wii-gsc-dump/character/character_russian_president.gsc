
main()
{
self setModel("body_russian_president");
self attach("head_russian_president", "", true);
self.headModel = "head_russian_president";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_president");
precacheModel("head_russian_president");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_president";
models[models.size]="head_russian_president";
return models;
}
