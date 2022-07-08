
main()
{
self setModel("hyena");
self.voice = "arab";
}
precache()
{
precacheModel("hyena");
}
enumerate_xmodels()
{
models = [];
models[models.size]="hyena";
return models;
}
