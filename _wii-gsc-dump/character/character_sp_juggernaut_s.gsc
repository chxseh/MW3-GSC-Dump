
main()
{
self setModel("body_complete_sp_juggernaut_s");
self.voice = "russian";
}
precache()
{
precacheModel("body_complete_sp_juggernaut_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_complete_sp_juggernaut_s";
return models;
}
