
main()
{
self setModel("body_sas_urban_smg");
self attach("head_sas_a", "", true);
self.headModel = "head_sas_a";
self.voice = "british";
}
precache()
{
precacheModel("body_sas_urban_smg");
precacheModel("head_sas_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_sas_urban_smg";
models[models.size]="head_sas_a";
return models;
}
