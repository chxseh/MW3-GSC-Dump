
main()
{
self setModel("body_dubai_male_c");
self.voice = "arab";
}
precache()
{
precacheModel("body_dubai_male_c");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_dubai_male_c";
return models;
}
