
main()
{
self setModel("fulllbody_russian_presidents_daughter_iw");
self.voice = "russian";
}
precache()
{
precacheModel("fulllbody_russian_presidents_daughter_iw");
}
enumerate_xmodels()
{
models = [];
models[models.size]="fulllbody_russian_presidents_daughter_iw";
return models;
}
