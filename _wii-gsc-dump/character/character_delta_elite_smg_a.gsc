
main()
{
self setModel("body_delta_elite_smg_a");
self attach("head_delta_elite_a", "", true);
self.headModel = "head_delta_elite_a";
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_smg_a");
precacheModel("head_delta_elite_a");
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_smg_a";
models[models.size]="head_delta_elite_a";
return models;
}
