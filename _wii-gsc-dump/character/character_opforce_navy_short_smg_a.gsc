
main()
{
self setModel("body_russian_navy_a_wii");
self attach("head_russian_navy_a_wii", "", true);
self.headModel = "head_russian_navy_a_wii";
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_navy_a_wii");
precacheModel("head_russian_navy_a_wii");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_navy_a_wii";
models[models.size]="head_russian_navy_a_wii";
return models;
}
