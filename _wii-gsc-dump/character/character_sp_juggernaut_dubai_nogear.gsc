
main()
{
self setModel("body_juggernaut_nogear");
self attach("head_hero_yuri_a", "", true);
self.headModel = "head_hero_yuri_a";
self.voice = "british";
}
precache()
{
precacheModel("body_juggernaut_nogear");
precacheModel("head_hero_yuri_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_juggernaut_nogear";
models[models.size]="head_hero_yuri_a";
return models;
}
