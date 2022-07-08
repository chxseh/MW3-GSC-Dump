
main()
{
self setModel("body_africa_militia_assault_a_s");
self attach("head_africa_militia_a_hat_s", "", true);
self.headModel = "head_africa_militia_a_hat_s";
if ( isendstr( self.headModel, "_hat" ) )
codescripts\character::attachHat( "alias_africa_militia_hats_a_s", xmodelalias\alias_africa_militia_hats_a_s::main() );
self.voice = "african";
}
precache()
{
precacheModel("body_africa_militia_assault_a_s");
precacheModel("head_africa_militia_a_hat_s");
codescripts\character::precacheModelArray(xmodelalias\alias_africa_militia_hats_a_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_africa_militia_assault_a_s";
models[models.size]="head_africa_militia_a_hat_s";
models = codescripts\character::array_append(models,xmodelalias\alias_africa_militia_hats_a_s::main());
return models;
}
