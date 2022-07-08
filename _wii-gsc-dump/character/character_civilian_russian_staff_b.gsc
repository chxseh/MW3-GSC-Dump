
main()
{
self setModel("body_fso_suit_a");
self attach("head_fso_a", "", true);
self.headModel = "head_fso_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_suit_a");
precacheModel("head_fso_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_suit_a";
models[models.size]="head_fso_a";
return models;
}
