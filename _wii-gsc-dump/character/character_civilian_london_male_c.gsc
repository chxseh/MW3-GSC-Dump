
main()
{
self setModel("body_urban_civ_male_ac");
self.voice = "british";
}
precache()
{
precacheModel("body_urban_civ_male_ac");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_urban_civ_male_ac";
return models;
}
