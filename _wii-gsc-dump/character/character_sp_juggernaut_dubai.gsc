
main()
{
self setModel("body_juggernaut");
self attach("head_juggernaut", "", true);
self.headModel = "head_juggernaut";
self.voice = "british";
}
precache()
{
precacheModel("body_juggernaut");
precacheModel("head_juggernaut");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_juggernaut";
models[models.size]="head_juggernaut";
return models;
}
