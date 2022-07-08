
main()
{
self setModel("villain_makarov_finale");
self.voice = "russian";
}
precache()
{
precacheModel("villain_makarov_finale");
}
enumerate_xmodels()
{
models = [];
models[models.size]="villain_makarov_finale";
return models;
}
