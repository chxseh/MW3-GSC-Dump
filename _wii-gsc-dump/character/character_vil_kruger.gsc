
main()
{
self setModel("body_warlord");
self attach("head_warlord", "", true);
self.headModel = "head_warlord";
self.voice = "african";
}
precache()
{
precacheModel("body_warlord");
precacheModel("head_warlord");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_warlord";
models[models.size]="head_warlord";
return models;
}
