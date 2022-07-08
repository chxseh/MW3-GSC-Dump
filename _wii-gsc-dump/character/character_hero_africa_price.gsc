
main()
{
self setModel("body_price_africe_wii");
self attach("head_price_africe_wii", "", true);
self.headModel = "head_price_africe_wii";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_price_africe_wii");
precacheModel("head_price_africe_wii");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_price_africe_wii";
models[models.size]="head_price_africe_wii";
return models;
}
