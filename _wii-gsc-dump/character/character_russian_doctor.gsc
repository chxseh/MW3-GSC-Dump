
main()
{
self setModel("body_doctor");
self attach("head_doctor", "", true);
self.headModel = "head_doctor";
self.voice = "russian";
}
precache()
{
precacheModel("body_doctor");
precacheModel("head_doctor");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_doctor";
models[models.size]="head_doctor";
return models;
}
