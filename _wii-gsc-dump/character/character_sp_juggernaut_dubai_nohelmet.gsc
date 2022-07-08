
main()
{
self setModel("body_juggernaut");
self attach("head_hero_yuri_a", "", true);
self.headModel = "head_hero_yuri_a";
self.voice = "british";
}
precache()
{
precacheModel("body_juggernaut");
precacheModel("head_hero_yuri_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_juggernaut";
models[models.size]="head_hero_yuri_a";
return models;
}
