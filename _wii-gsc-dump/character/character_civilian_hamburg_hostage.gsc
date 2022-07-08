
main()
{
self setModel("body_fso_suit_no_gun_a");
self attach("head_hostage_a", "", true);
self.headModel = "head_hostage_a";
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_suit_no_gun_a");
precacheModel("head_hostage_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_suit_no_gun_a";
models[models.size]="head_hostage_a";
return models;
}
