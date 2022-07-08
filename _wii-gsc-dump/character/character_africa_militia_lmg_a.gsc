
main()
{
self setModel("body_africa_militia_assault_a");
self attach("head_africa_militia_a_hat", "", true);
self.headModel = "head_africa_militia_a_hat";
if ( isendstr( self.headModel, "_hat" ) )
codescripts\character::attachHat( "alias_africa_militia_hats_a", xmodelalias\alias_africa_militia_hats_a::main() );
self.voice = "african";
}
precache()
{
precacheModel("body_africa_militia_assault_a");
precacheModel("head_africa_militia_a_hat");
codescripts\character::precacheModelArray(xmodelalias\alias_africa_militia_hats_a::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_africa_militia_assault_a";
models[models.size]="head_africa_militia_a_hat";
models = codescripts\character::array_append(models,xmodelalias\alias_africa_militia_hats_a::main());
return models;
}
