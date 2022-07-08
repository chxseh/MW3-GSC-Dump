
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_so_martyrdom_smg_bodies_s::main());
self attach("head_opforce_arab_c_s", "", true);
self.headModel = "head_opforce_arab_c_s";
self.voice = "russian";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_so_martyrdom_smg_bodies_s::main());
precacheModel("head_opforce_arab_c_s");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_so_martyrdom_smg_bodies_s::main());
models[models.size]="head_opforce_arab_c_s";
return models;
}
