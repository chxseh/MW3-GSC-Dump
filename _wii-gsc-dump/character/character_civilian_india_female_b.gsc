
main()
{
self setModel("body_india_civ_female_a_2");
self.voice = "arab";
}
precache()
{
precacheModel("body_india_civ_female_a_2");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_india_civ_female_a_2";
return models;
}
