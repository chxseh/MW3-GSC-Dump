
main()
{
self setModel("body_fso_vest_a");
self attach("head_fso_commander", "", true);
self.headModel = "head_fso_commander";
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_vest_a");
precacheModel("head_fso_commander");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_vest_a";
models[models.size]="head_fso_commander";
return models;
}
