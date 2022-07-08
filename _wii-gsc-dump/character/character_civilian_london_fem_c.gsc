
main()
{
self setModel("body_urban_civ_female_a");
self.voice = "british";
}
precache()
{
precacheModel("body_urban_civ_female_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_urban_civ_female_a";
return models;
}
