
main()
{
self setModel("body_prague_civ_female_drone_a");
self.voice = "russian";
}
precache()
{
precacheModel("body_prague_civ_female_drone_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_prague_civ_female_drone_a";
return models;
}
