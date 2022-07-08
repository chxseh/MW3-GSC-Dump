
main()
{
self setModel("body_gign_paris_assault");
self attach("head_gign_a", "", true);
self.headModel = "head_gign_a";
self.voice = "french";
}
precache()
{
precacheModel("body_gign_paris_assault");
precacheModel("head_gign_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_gign_paris_assault";
models[models.size]="head_gign_a";
return models;
}
