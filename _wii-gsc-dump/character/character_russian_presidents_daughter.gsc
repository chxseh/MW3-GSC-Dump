
main()
{
self setModel("russian_presidents_daughter_body");
self.voice = "russian";
}
precache()
{
precacheModel("russian_presidents_daughter_body");
}
enumerate_xmodels()
{
models = [];
models[models.size]="russian_presidents_daughter_body";
return models;
}
