
main()
{
self setModel("body_airport_com_a");
self attach("head_vil_makarov", "", true);
self.headModel = "head_vil_makarov";
self.voice = "seal";
}
precache()
{
precacheModel("body_airport_com_a");
precacheModel("head_vil_makarov");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_airport_com_a";
models[models.size]="head_vil_makarov";
return models;
}
