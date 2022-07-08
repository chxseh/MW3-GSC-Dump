
main()
{
self setModel("body_india_civ_female_a");
self.voice = "arab";
}
precache()
{
precacheModel("body_india_civ_female_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_india_civ_female_a";
return models;
}
