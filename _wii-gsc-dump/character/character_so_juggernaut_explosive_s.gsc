
main()
{
self setModel("fullbody_juggernaut_explosive_so_s");
self.voice = "russian";
}
precache()
{
precacheModel("fullbody_juggernaut_explosive_so_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="fullbody_juggernaut_explosive_so_s";
return models;
}
