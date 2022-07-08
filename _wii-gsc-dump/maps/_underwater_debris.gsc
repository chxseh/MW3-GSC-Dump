#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
CONST_VOLUME_X = 128;
CONST_VOLUME_Y = 128;
CONST_VOLUME_Z = 128;
CONST_MIN_DIM = -131072;
CONST_MAX_DIM = 131072;
main()
{
setup_debris_groups();
setup_debris_volumes();
level.dv_hash = [];
level.dv_counts = [];
}
get_dv_hash(origin)
{
hash_scale_y = int((CONST_MAX_DIM - CONST_MIN_DIM)/CONST_VOLUME_X);
hash_scale_z = int(hash_scale_y * ((CONST_MAX_DIM - CONST_MIN_DIM)/CONST_VOLUME_Y));
x = int((origin[0]-CONST_MIN_DIM)/CONST_VOLUME_X);
y = int((origin[1]-CONST_MIN_DIM)/CONST_VOLUME_Y);
z = int((origin[2]-CONST_MIN_DIM)/CONST_VOLUME_Z);
hash = int(x + (hash_scale_y*y) + (hash_scale_z*z));
return "" + hash;
}
setup_debris_groups()
{
const_body_id = 1;
const_max_bodies = 30;
const_floating_id = 2;
const_max_floating = 50;
assertex(!isdefined(level.dv_groups), "setup_debris_system should only be called once" );
dg = spawnstruct();
dg.debris[0]["model"][0] = "c130_engine_dyn";
dg.debris[0]["model"][1] = "727_cabin_door_dyn";
dg.debris[0]["model"][2] = "727_coach_seat01_dyn";
dg.debris[0]["model"][3] = "727_wing_flaps_long_left_new_dyn";
dg.debris[0]["model"][4] = "727_wing_flaps_short_left_new_dyn";
dg.debris[0]["model"][5] = "c130_engine_damaged_dyn";
dg.debris[0]["class"] = "sinker";
dg.debris[0]["classname"] = "script_model";
dg.debris[0]["spawnflags"] = 0;
dg.debris[0]["number"] = 5;
dg.debris[0]["density"] = 0.05;
dg.debris[0]["sinkvel"] = 10;
dg.debris[0]["sinkrot"] = 1;
dg.debris[0]["id"] = 0;
dg.debris[1]["model"][0] = "body_russian_navy_sleevesdown";
dg.debris[1]["model"][1] = "body_russian_navy_sleevesrolled";
dg.debris[1]["headmodel"][0] = "head_russian_navy_a";
dg.debris[1]["headmodel"][1] = "head_russian_navy_b";
dg.debris[1]["headmodel"][2] = "head_russian_navy_c";
dg.debris[1]["class"] = "body";
dg.debris[1]["classname"] = "script_model";
dg.debris[1]["animation"][0] = "harbor_drowning_01_idle";
dg.debris[1]["animation"][1] = "harbor_drowning_02_idle";
dg.debris[1]["animation"][2] = "harbor_drowning_03_idle";
dg.debris[1]["spawnflags"] = 0;
dg.debris[1]["number"] = 5;
dg.debris[1]["density"] = 0.01;
dg.debris[1]["sinkvel"] = 4;
dg.debris[1]["sinkrot"] = 1;
dg.debris[1]["max_total_number"] = const_max_bodies;
dg.debris[1]["cur_total_number"] = 0;
dg.debris[1]["id"] = const_body_id;
dg.debris[2]["model"][0] = "body_russian_navy_sleevesdown";
dg.debris[2]["model"][1] = "body_russian_navy_sleevesrolled";
dg.debris[2]["headmodel"][0] = "head_russian_navy_a";
dg.debris[2]["headmodel"][1] = "head_russian_navy_b";
dg.debris[2]["headmodel"][2] = "head_russian_navy_c";
dg.debris[2]["class"] = "floater";
dg.debris[2]["classname"] = "script_model";
dg.debris[2]["animation"][0][0] = "harbor_drowning_01";
dg.debris[2]["animation"][0][1] = "harbor_drowning_01_idle";
dg.debris[2]["animation"][1][0] = "harbor_drowning_02";
dg.debris[2]["animation"][1][1] = "harbor_drowning_02_idle";
dg.debris[2]["animation"][2][0] = "harbor_drowning_03";
dg.debris[2]["animation"][2][1]	= "harbor_drowning_03_idle";
dg.debris[2]["animation"][3]	= "harbor_floating_struggle_01";
dg.debris[2]["animation"][4]	= "harbor_floating_struggle_02";
dg.debris[2]["animation"][5]	= "harbor_floating_idle_01";
dg.debris[2]["animation"][6]	= "harbor_floating_idle_02";
dg.debris[2]["animation"][7]	= "harbor_floating_idle_03";
dg.debris[2]["spawnflags"] = 0;
dg.debris[2]["number"] = 5;
dg.debris[2]["density"] = 0.10;
dg.debris[2]["min_start_delay"] = 1;
dg.debris[2]["max_start_delay"] = 10;
dg.debris[2]["max_total_number"] = const_max_floating;
dg.debris[2]["cur_total_number"] = 0;
dg.debris[2]["id"] = const_floating_id;
level.dv_groups[ "default" ] = dg;
surfaceonly = spawnstruct();
surfaceonly.debris[0]["model"][0] = "body_russian_navy_sleevesdown";
surfaceonly.debris[0]["model"][1] = "body_russian_navy_sleevesrolled";
surfaceonly.debris[0]["headmodel"][0] = "head_russian_navy_a";
surfaceonly.debris[0]["headmodel"][1] = "head_russian_navy_b";
surfaceonly.debris[0]["headmodel"][2] = "head_russian_navy_c";
surfaceonly.debris[0]["class"] = "floater";
surfaceonly.debris[0]["classname"] = "script_model";
surfaceonly.debris[0]["animation"][0][0] = "harbor_drowning_01";
surfaceonly.debris[0]["animation"][0][1] = "harbor_drowning_01_idle";
surfaceonly.debris[0]["animation"][1][0] = "harbor_drowning_02";
surfaceonly.debris[0]["animation"][1][1] = "harbor_drowning_02_idle";
surfaceonly.debris[0]["animation"][2][0] = "harbor_drowning_03";
surfaceonly.debris[0]["animation"][2][1]	= "harbor_drowning_03_idle";
surfaceonly.debris[0]["animation"][3]	= "harbor_floating_struggle_01";
surfaceonly.debris[0]["animation"][4]	= "harbor_floating_struggle_02";
surfaceonly.debris[0]["animation"][5]	= "harbor_floating_idle_01";
surfaceonly.debris[0]["animation"][6]	= "harbor_floating_idle_02";
surfaceonly.debris[0]["animation"][7]	= "harbor_floating_idle_03";
surfaceonly.debris[0]["spawnflags"] = 0;
surfaceonly.debris[0]["number"] = 5;
surfaceonly.debris[0]["density"] = 0.20;
surfaceonly.debris[0]["min_start_delay"] = 1;
surfaceonly.debris[0]["max_start_delay"] = 10;
surfaceonly.debris[0]["max_total_number"] = const_max_floating;
surfaceonly.debris[0]["cur_total_number"] = 0;
surfaceonly.debris[0]["id"] = const_floating_id;
level.dv_groups[ "surface_only" ] = surfaceonly;
surfaceonly = spawnstruct();
surfaceonly.debris[0]["model"][0] = "body_russian_navy_sleevesdown";
surfaceonly.debris[0]["model"][1] = "body_russian_navy_sleevesrolled";
surfaceonly.debris[0]["headmodel"][0] = "head_russian_navy_a";
surfaceonly.debris[0]["headmodel"][1] = "head_russian_navy_b";
surfaceonly.debris[0]["headmodel"][2] = "head_russian_navy_c";
surfaceonly.debris[0]["class"] = "deadbody";
surfaceonly.debris[0]["classname"] = "script_model";
surfaceonly.debris[0]["animation"][0]	= "harbor_floating_idle_04";
surfaceonly.debris[0]["spawnflags"] = 0;
surfaceonly.debris[0]["number"] = 5;
surfaceonly.debris[0]["density"] = 0.20;
surfaceonly.debris[0]["min_start_delay"] = 1;
surfaceonly.debris[0]["max_start_delay"] = 10;
surfaceonly.debris[0]["max_total_number"] = const_max_bodies;
surfaceonly.debris[0]["cur_total_number"] = 0;
surfaceonly.debris[0]["id"] = const_body_id;
level.dv_groups[ "inpath" ] = surfaceonly;
PreCacheModel("c130_engine_dyn");
PreCacheModel("727_cabin_door_dyn");
PreCacheModel("727_coach_seat01_dyn");
PreCacheModel("727_wing_flaps_long_left_new_dyn");
PreCacheModel("727_wing_flaps_short_left_new_dyn");
PreCacheModel("c130_engine_damaged_dyn");
PreCacheModel("body_russian_navy_sleevesdown");
PreCacheModel("body_russian_navy_sleevesrolled");
PreCacheModel("head_russian_navy_a");
PreCacheModel("head_russian_navy_b");
PreCacheModel("head_russian_navy_c");
}
setup_debris_volumes()
{
volumes = getentarray( "info_volume", "code_classname" );
foreach (volume in volumes)
{
if (isdefined(volume.script_noteworthy) && (volume.script_noteworthy == "debris_volume"))
{
AddDebrisVolume(volume);
}
}
if (isdefined(level.dv_volumes))
{
foreach (dv_info in level.dv_volumes)
{
dv_info thread wait_for_debris_volume_trigger();
}
}
}
AddDebrisVolume( volume )
{
volume.active = false;
start_trigger = undefined;
end_trigger = undefined;
start_trigger_name = undefined;
if (isdefined(volume.target))
{
start_trigger_name = volume.target;
start_trigger = getent( volume.target, "targetname" );
if ( isdefined(start_trigger) && isdefined(start_trigger.target) )
{
end_trigger = getent( start_trigger.target, "targetname");
}
}
if (!isdefined(start_trigger))
{
assertex( false, "Debris volumes must target the start trigger" );
return;
}
if (!isdefined(level.dv_volumes) || (!isdefined(level.dv_volumes[start_trigger_name])))
{
dv_info = spawnstruct();
dv_info.volumes[0] = volume;
dv_info.start_trigger = start_trigger;
dv_info.end_trigger = end_trigger;
dv_info.active = false;
level.dv_volumes[start_trigger_name] = dv_info;
}
else
{
idx = level.dv_volumes[start_trigger_name].volumes.size;
level.dv_volumes[start_trigger_name].volumes[idx] = volume;
}
}
wait_for_debris_volume_trigger()
{
while (true)
{
self.start_trigger waittill("trigger");
self.active = true;
foreach (volume in self.volumes)
{
volume PopulateDebris();
}
if (!isdefined(self.end_trigger))
{
return;
}
self.end_trigger waittill("trigger");
self.active = false;
foreach (volume in self.volumes)
{
volume DestroyDebris();
}
}
}
PopulateDebris()
{
origin0 = self GetPointInBounds(-1, -1, -1);
origin1 = self GetPointInBounds(1, 1, 1);
diag = origin1 - origin0;
volume = abs(diag[0]) * abs(diag[1]) * abs(diag[2]);
volume = volume / (CONST_VOLUME_X*CONST_VOLUME_Y*CONST_VOLUME_Z);
area = abs(diag[0]) * abs(diag[1]);
area = area / (CONST_VOLUME_X*CONST_VOLUME_Y);
group = "default";
if (isdefined(self.script_parameters))
group = self.script_parameters;
if (!isdefined(level.dv_groups[group]))
{
assertex( false, "Undefined dv_group " + group);
return;
}
dg = level.dv_groups[group];
foreach (type in dg.debris)
{
count = type["number"];
class = type["class"];
id = type["id"];
if (isdefined(type["density"]))
{
density = type["density"];
if (class == "floater")
count = Int(area * density);
else
count = Int(volume * density);
}
numperframe = 2;
perframecnt = 0;
for (i=0; i<count; i++)
{
ent = undefined;
if (!isdefined(type["max_total_number"]) || !isdefined(level.dv_counts[id]) || (level.dv_counts[id] < type["max_total_number"]))
{
switch( class )
{
case "static":
ent = Spawn_Static( type, self );
break;
case "sinker":
ent = Spawn_Sinker( type, self );
break;
case "body":
ent = Spawn_Body( type, self );
break;
case "floater":
ent = Spawn_Floater( type, self );
break;
case "deadbody":
ent = Spawn_DeadBody( type, self );
break;
case "fx":
ent = Spawn_Fx( type, self );
break;
};
if (isdefined(ent))
{
perframecnt++;
if (!isdefined(self.debris_list))
{
self.debris_list[0] = ent;
}
else
{
self.debris_list[self.debris_list.size] = ent;
}
ent.dv_id = id;
if (isdefined(type["max_total_number"]))
{
if (!isdefined(level.dv_counts[ent.dv_id]))
level.dv_counts[ent.dv_id] = 0;
level.dv_counts[ent.dv_id]++;
}
}
if (perframecnt >= numperframe)
{
perframecnt = 0;
wait 0.05;
}
}
}
}
}
DestroyDebris()
{
if (isdefined(self.debris_list))
{
foreach (debris in self.debris_list)
{
if (isdefined(debris.dv_hash) && (debris.dv_hash != "0"))
level.dv_hash[debris.dv_hash] = undefined;
if (isdefined(level.dv_counts[debris.dv_id]))
level.dv_counts[debris.dv_id]--;
debris delete();
}
self.debris_list = undefined;
}
}
SpawnEntInVolume( volume, classname, model, spawnflags, surfaceflag )
{
if (!(isdefined(surfaceflag) && surfaceflag && isdefined(level.underwater_z)))
surfaceflag = false;
origin = (0,0,0);
hash = 0;
for (i=0; i<10; i++)
{
x = RandomFloatRange(-1,1);
y = RandomFloatRange(-1,1);
z = RandomFloatRange(-1,1);
origin = volume GetPointInBounds(x, y, z);
if ( surfaceflag )
{
origin = (origin[0], origin[1], level.underwater_z);
}
hash = get_dv_hash(origin);
if (!isdefined(level.dv_hash[hash]))
break;
else
hash = 0;
}
ent = spawn( classname, origin, spawnflags );
ent.dv_hash = hash;
if (hash != "0")
level.dv_hash[hash] = ent;
ent SetModel( model );
x = RandomFloatRange(-180,180);
y = RandomFloatRange(-180,180);
z = RandomFloatRange(-180,180);
if (surfaceflag)
{
x = 0;
z = 0;
}
ent.angles = (x, y, z);
return ent;
}
Spawn_Static( type, volume)
{
if (isarray(type["model"]))
model = random(type["model"]);
else
model = type["model"];
ent = SpawnEntInVolume( volume, type["classname"], model, type["spawnflags"] );
return ent;
}
Spawn_Sinker( type, volume)
{
if (isarray(type["model"]))
model = random(type["model"]);
else
model = type["model"];
ent = SpawnEntInVolume( volume, type["classname"], model, type["spawnflags"] );
ent thread Sinking( type, volume );
return ent;
}
Sink( falling_vel, rotateWhileSinking )
{
self endon("death");
trace = BulletTrace( (self.origin+(0,0,12)), self.origin+(0,0,-12000), false, undefined);
ground = trace["position"];
dist = distance(self.origin, ground);
t = dist/falling_vel;
self MoveTo( ground, t, 0, 0);
if (rotateWhileSinking)
{
x = RandomFloatRange(-4,4);
y = RandomFloatRange(-4,4);
z = RandomFloatRange(-4,4);
self RotateVelocity( (x, y, z), t, 0, 0);
}
wait t;
}
Sinking( type, volume )
{
self endon("death");
if (isdefined(type["sinkvel"]))
{
falling_vel = type["sinkvel"];
if (falling_vel != 0)
self Sink( falling_vel, isdefined(type["sinkrot"]) );
}
}
Spawn_Body( type, volume)
{
if (isarray(type["model"]))
model = random(type["model"]);
else
model = type["model"];
ent = SpawnEntInVolume( volume, type["classname"], model, type["spawnflags"] );
ent.animname = "floating_body";
ent SetAnimTree();
if (isdefined(type["headmodel"]))
{
if (isarray(type["headmodel"]))
headmodel = random(type["headmodel"]);
else
headmodel = type["headmodel"];
ent attach(headmodel, "", true );
}
if (isarray(type["animation"]))
animation = random(type["animation"]);
else
animation = type["animation"];
ent thread anim_generic_loop( ent, animation );
ent thread Body( type, volume );
return ent;
}
Body( type, volume )
{
self endon("death");
if (isdefined(type["sinkvel"]))
{
falling_vel = type["sinkvel"];
if (falling_vel != 0)
self Sink( falling_vel, isdefined(type["sinkrot"]) );
}
}
Spawn_Floater( type, volume)
{
if (isarray(type["model"]))
model = random(type["model"]);
else
model = type["model"];
ent = SpawnEntInVolume( volume, type["classname"], model, type["spawnflags"], true );
ent.animname = "floating_body";
ent SetAnimTree();
if (isdefined(type["headmodel"]))
{
if (isarray(type["headmodel"]))
headmodel = random(type["headmodel"]);
else
headmodel = type["headmodel"];
ent attach(headmodel, "", true );
}
animation = random(type["animation"]);
ent thread Floater( type, volume, animation );
return ent;
}
Floater( type, volume, animation )
{
self endon("death");
if (isarray(animation))
{
self anim_generic_first_frame( self, animation[0] );
while (true)
{
dist = Distance2D(level.player.origin, self.origin );
if (dist < 1200)
break;
wait 0.2;
}
wait RandomFloatRange(type["min_start_delay"],type["max_start_delay"]);
self anim_generic( self, animation[0] );
nxtanim = animation[1];
}
else
nxtanim = animation;
self anim_generic_loop( self, nxtanim );
}
AddDeadBodyToFakePhysics( bodyent )
{
tag_origin = spawn_tag_origin();
tag_origin.origin = bodyent.origin;
tag_origin.angles = bodyent.angles;
bodyent.tag_origin = tag_origin;
bodyent linkto(tag_origin,"tag_origin");
if (!isdefined(level._physics_dead_bodies))
level._physics_dead_bodies[0] = bodyent;
else
level._physics_dead_bodies[level._physics_dead_bodies.size] = bodyent;
bodyent thread CleanupDeadBodyAtDeath();
}
RemoveDeadBodyToFakePhysics( bodyent )
{
level._physics_dead_bodies = array_remove( level._physics_dead_bodies, bodyent );
}
CleanupDeadBodyAtDeath()
{
self waittill( "death" );
RemoveDeadBodyToFakePhysics( self );
self.tag_origin Delete();
}
Spawn_DeadBody( type, volume)
{
if (isarray(type["model"]))
model = random(type["model"]);
else
model = type["model"];
ent = SpawnEntInVolume( volume, type["classname"], model, type["spawnflags"] );
ent.animname = "floating_body";
ent SetAnimTree();
if (isdefined(type["headmodel"]))
{
if (isarray(type["headmodel"]))
headmodel = random(type["headmodel"]);
else
headmodel = type["headmodel"];
ent attach(headmodel, "", true );
}
if (isarray(type["animation"]))
animation = random(type["animation"]);
else
animation = type["animation"];
ent thread anim_generic_loop( ent, animation );
AddDeadBodyToFakePhysics( ent );
ent thread DeadBody( type, volume );
return ent;
}
DeadBody( type, volume )
{
self endon("death");
}
Spawn_FX( type, volume)
{
}
draw_bounding_volume()
{
colr = ( 1,1,1 );
p[0] = self GetPointInBounds(-1, -1, -1);
p[1] = self GetPointInBounds(-1, -1, 1);
p[2] = self GetPointInBounds(-1, 1, -1);
p[3] = self GetPointInBounds(-1, 1, 1);
p[4] = self GetPointInBounds( 1, -1, -1);
p[5] = self GetPointInBounds( 1, -1, 1);
p[6] = self GetPointInBounds( 1, 1, -1);
p[7] = self GetPointInBounds( 1, 1, 1);
for (i=0; i<8; i += 2)
line( p[i], p[i+1], colr );
for (i=0; i<4; i += 1)
line( p[i], p[i+4], colr );
for (i=0; i<2; i += 1)
line( p[i], p[i+2], colr );
for (i=4; i<5; i += 1)
line( p[i], p[i+2], colr );
}
debug_thread()
{
while (true)
{
foreach (id, count in level.dv_counts)
{
iprintln("dvc " + id + " = " + count);
}
foreach (name, dv in level.dv_volumes)
{
if (dv.active)
{
iprintln("dv " + name + " active");
foreach (volume in dv.volumes)
volume draw_bounding_volume();
}
}
wait 0.05;
}
}
