
main()
{
self setModel("fullbody_london_wife");
self.voice = "american";
}
precache()
{
precacheModel("fullbody_london_wife");
}
enumerate_xmodels()
{
models = [];
models[models.size]="fullbody_london_wife";
return models;
}
