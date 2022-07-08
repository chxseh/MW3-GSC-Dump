
main()
{
self setModel("body_fso_suit_advisor");
self attach("head_fso_advisor", "", true);
self.headModel = "head_fso_advisor";
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_suit_advisor");
precacheModel("head_fso_advisor");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_suit_advisor";
models[models.size]="head_fso_advisor";
return models;
}
