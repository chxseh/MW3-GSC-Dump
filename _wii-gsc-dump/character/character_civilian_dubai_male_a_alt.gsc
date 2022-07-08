
main()
{
self setModel("body_dubai_male_a_alt");
self attach("head_dubai_male_c", "", true);
self.headModel = "head_dubai_male_c";
self.voice = "arab";
}
precache()
{
precacheModel("body_dubai_male_a_alt");
precacheModel("head_dubai_male_c");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_dubai_male_a_alt";
models[models.size]="head_dubai_male_c";
return models;
}
