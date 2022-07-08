
main()
{
self setModel("body_soap_europe_wii");
self attach("head_soap_europe_injured_wii", "", true);
self.headModel = "head_soap_europe_injured_wii";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_soap_europe_wii");
precacheModel("head_soap_europe_injured_wii");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_soap_europe_wii";
models[models.size]="head_soap_europe_injured_wii";
return models;
}
