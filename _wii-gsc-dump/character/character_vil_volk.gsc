
main()
{
self setModel("body_volk_a");
self.voice = "russian";
}
precache()
{
precacheModel("body_volk_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_volk_a";
return models;
}
