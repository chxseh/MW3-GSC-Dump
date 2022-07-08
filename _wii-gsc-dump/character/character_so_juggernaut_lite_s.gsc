
main()
{
self setModel("fullbody_juggernaut_c_s");
self.voice = "russian";
}
precache()
{
precacheModel("fullbody_juggernaut_c_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="fullbody_juggernaut_c_s";
return models;
}
