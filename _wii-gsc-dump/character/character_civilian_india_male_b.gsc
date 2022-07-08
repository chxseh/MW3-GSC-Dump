
main()
{
self setModel("body_india_civ_male_aa");
self.voice = "arab";
}
precache()
{
precacheModel("body_india_civ_male_aa");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_india_civ_male_aa";
return models;
}
