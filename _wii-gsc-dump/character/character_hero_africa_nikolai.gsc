
main()
{
self setModel("body_nikolai_africa_assault_a");
self attach("head_nikolai_africa_assault_a", "", true);
self.headModel = "head_nikolai_africa_assault_a";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_nikolai_africa_assault_a");
precacheModel("head_nikolai_africa_assault_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_nikolai_africa_assault_a";
models[models.size]="head_nikolai_africa_assault_a";
return models;
}
