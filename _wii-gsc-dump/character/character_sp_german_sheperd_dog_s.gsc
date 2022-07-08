
main()
{
self setModel("german_sheperd_dog_s");
self.voice = "arab";
}
precache()
{
precacheModel("german_sheperd_dog_s");
}
enumerate_xmodels()
{
models = [];
models[models.size]="german_sheperd_dog_s";
return models;
}
