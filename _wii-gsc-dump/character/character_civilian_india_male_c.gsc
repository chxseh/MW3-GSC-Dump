
main()
{
self setModel("body_india_civ_male_a");
self.voice = "arab";
}
precache()
{
precacheModel("body_india_civ_male_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_india_civ_male_a";
return models;
}
