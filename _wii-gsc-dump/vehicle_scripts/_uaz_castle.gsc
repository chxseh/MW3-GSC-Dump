#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
vehicle_scripts\_uaz::main(model, type, classname);
level.vehicle_aianims[ classname ] = setoverrideanims( classname );
build_drive( %castle_truck_escape_drive_idle_truck, %uaz_driving_idle_backward,10);
}
#using_animtree( "generic_human" );
setoverrideanims(classname)
{
positions = level.vehicle_aianims[ classname ];
positions[ 0 ].getin = %castle_truck_escape_mount_price;
positions[ 0 ].idle = %castle_truck_escape_drive_idle_price;
setoverridevehicleanims(positions);
return positions;
}
#using_animtree( "vehicles" );
setoverridevehicleanims(positions)
{
positions[ 0 ].vehicle_getinanim = %castle_truck_escape_mount_truck;
}



