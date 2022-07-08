
main()
{
self setModel("body_price_europe_assault_a");
self attach("head_price_africe_wii", "", true);
self.headModel = "head_price_africe_wii";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_price_europe_assault_a");
precacheModel("head_price_africe_wii");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_price_europe_assault_a";
models[models.size]="head_price_africe_wii";
return models;
}
