
main()
{
self setModel("body_russian_naval_captain_a");
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_naval_captain_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_naval_captain_a";
return models;
}
