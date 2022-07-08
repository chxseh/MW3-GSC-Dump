
main()
{
self setModel("body_urban_civ_male_ab");
self.voice = "british";
}
precache()
{
precacheModel("body_urban_civ_male_ab");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_urban_civ_male_ab";
return models;
}
