
main()
{
self setModel("london_civ_end_littlegirl");
self.voice = "american";
}
precache()
{
precacheModel("london_civ_end_littlegirl");
}
enumerate_xmodels()
{
models = [];
models[models.size]="london_civ_end_littlegirl";
return models;
}
