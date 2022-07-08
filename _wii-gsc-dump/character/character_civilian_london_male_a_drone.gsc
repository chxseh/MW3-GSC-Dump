
main()
{
self setModel("body_urban_civ_male_aa");
self.voice = "british";
}
precache()
{
precacheModel("body_urban_civ_male_aa");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_urban_civ_male_aa";
return models;
}
