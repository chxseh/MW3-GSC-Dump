
main()
{
self setModel("body_delta_elite_smg_a");
self attach("head_truck_delta", "", true);
self.headModel = "head_truck_delta";
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_smg_a");
precacheModel("head_truck_delta");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_smg_a";
models[models.size]="head_truck_delta";
return models;
}
