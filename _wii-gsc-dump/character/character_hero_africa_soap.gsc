
main()
{
self setModel("body_soap_africa_assault_a");
self attach("head_soap_africa_assault_a", "", true);
self.headModel = "head_soap_africa_assault_a";
self.voice = "taskforce";
}
precache()
{
precacheModel("body_soap_africa_assault_a");
precacheModel("head_soap_africa_assault_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_soap_africa_assault_a";
models[models.size]="head_soap_africa_assault_a";
return models;
}
