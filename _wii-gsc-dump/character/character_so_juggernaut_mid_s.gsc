
main()
{
self setModel("fullbody_juggernaut_novisor_b_s");
self.voice = "russian";
}
precache()
{
precacheModel("fullbody_juggernaut_novisor_b_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="fullbody_juggernaut_novisor_b_s";
return models;
}
