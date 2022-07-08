
main()
{
self setModel("body_villain_makarov_hijack");
self.voice = "russian";
}
precache()
{
precacheModel("body_villain_makarov_hijack");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_villain_makarov_hijack";
return models;
}
