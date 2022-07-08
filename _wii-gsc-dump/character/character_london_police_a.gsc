
main()
{
self setModel("london_cop_wii");
self.voice = "british";
}
precache()
{
precacheModel("london_cop_wii");
}
enumerate_xmodels()
{
models = [];
models[models.size]="london_cop_wii";
return models;
}
