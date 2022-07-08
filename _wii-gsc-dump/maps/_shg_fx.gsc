#include common_scripts\utility;
#include maps\_utility;
#include common_scripts\_createfx;
#include common_scripts\_fx;
#include common_scripts\_createfxMenu;
setup_shg_fx()
{
level.createFXexploders = [];
foreach ( ent in level.createFXent )
{
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
id = ent.v[ "exploder" ];
if (!isdefined(level.createFXexploders[ id ]))
level.createFXexploders[ id ] = [];
level.createFXexploders[ id ][level.createFXexploders[ id ].size] = ent;
}
level.createFXbyFXID = [];
foreach ( ent in level.createFXent )
{
if ( !isdefined( ent ) )
continue;
if ( !isdefined( ent.v[ "fxid" ] ) )
continue;
fxid = ent.v[ "fxid" ];
if (!isdefined(level.createFXbyFXID[ fxid ]))
level.createFXbyFXID[ fxid ] = [];
level.createFXbyFXID[ fxid ][level.createFXbyFXID[ fxid ].size] = ent;
}
}
GetExploders( id )
{
id = string(id);
if (isdefined(level.createFXexploders))
return level.createFXexploders[ id ];
array = [];
foreach (ent in level.createFxent)
{
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
if ( ent.v[ "exploder" ] == id )
array[array.size] = ent;
}
return array;
}
GetEntsByFXID( id )
{
id = string(id);
if (isdefined(level.createFXbyFXID))
return level.createFXbyFXID[ id ];
array = [];
foreach (ent in level.createFxent)
{
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "fxid" ] == id )
array[array.size] = ent;
}
return array;
}
pauseExploders( num )
{
exploders = GetExploders( num );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
ent pauseEffect();
}
}
}
PauseFXID( fxid )
{
exploders = GetEntsByFXID( fxid );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
ent pauseEffect();
}
}
}
RestartFXID( fxid, type )
{
exploders = GetEntsByFXID( fxid );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if (isdefined(type) && (ent.v["type"] == type))
continue;
ent restartEffect();
}
}
}
matrix33(inVec1,inVec2,inVec3)
{
m33 = spawnStruct();
m33.cols[0]=vectornormalize(inVec1);
m33.cols[1]=vectornormalize(inVec2);
m33.cols[2]=vectornormalize(inVec3);
}
vec3_mult_matrix33(inVec,inMatrix)
{
inVec = vectornormalize(inVec);
newX = vectordot(inVec,inMatrix.cols[0]);
newY = vectordot(inVec,inMatrix.cols[0]);
newZ = vectordot(inVec,inMatrix.cols[0]);
return (newX,newY,newZ);
}
RUMBLE_FRAMES_PER_SEC = 10;
screenshake( scale, duration, fade_in, fade_out)
{
if ( !isdefined( fade_in ) )
fade_in = 0;
if ( !isdefined( fade_out ) )
fade_out = 0;
assert( ( fade_in + fade_out ) <= duration );
frame_count = duration * RUMBLE_FRAMES_PER_SEC;
fade_in_frame_count = fade_in * RUMBLE_FRAMES_PER_SEC;
if ( fade_in_frame_count > 0 )
fade_in_scale_step = scale / fade_in_frame_count;
else
fade_in_scale_step = scale;
fade_out_frame_count = fade_out * RUMBLE_FRAMES_PER_SEC;
fade_out_start_frame = frame_count - fade_out_frame_count;
if ( fade_out_frame_count > 0 )
fade_out_scale_step = scale / fade_out_frame_count;
else
fade_out_scale_step = scale;
delay = 1/RUMBLE_FRAMES_PER_SEC;
scale = 0;
for ( i = 0; i < frame_count; i++ )
{
if ( i <= fade_in_frame_count )
scale += fade_in_scale_step;
if ( i > fade_out_start_frame )
scale -= fade_out_scale_step;
earthquake( scale, delay, level.player.origin, 500 );
wait delay;
}
}
fx_bombShakes( fxid , rumbleid , shakescale, shakeduration, shakerampin, shakerampout, do_phys_jitter, b_forceshake)
{
if(level.createfx_enabled) return 0;
to1 = spawn_tag_origin();
offsetDist = 1200;
to1.origin = level.player getorigin();
trace = BulletTrace( (level.player.origin+(0,0,12)), level.player.origin+(0,0,1200), false, undefined);
hitDist = distance(to1.origin,trace["position"]);
f_shakescale = .125;
f_shakeduration = 2;
f_shakerampin = .3;
f_shakerampout = .5;
if(Isdefined(shakescale))
{
f_shakescale = shakescale;
}
if(Isdefined(shakeduration))
{
f_shakeduration = shakeduration;
}
if(Isdefined(shakerampin))
{
f_shakerampin = shakerampin;
}
if(Isdefined(shakerampout))
{
f_shakerampout = shakerampout;
}
if(IsDefined(b_forceshake) && b_forceshake == 1)
hitDist = 1;
if(hitDist<300)
{
if(Isdefined(rumbleid))
{
level.player playrumbleonentity(rumbleid);
}
level thread screenshake(f_shakescale,f_shakeduration,f_shakerampin,f_shakerampout);
if(IsDefined(do_phys_jitter) && do_phys_jitter == 1)
level thread fx_bombshakes_physics_jitter(to1.origin, f_shakeduration, f_shakescale);
if(Isdefined(fxid))
{
for(i=0;i<6;i++)
{
wait(.1);
tracedir = vectornormalize(anglestoforward(level.player getplayerangles())+(randomfloatrange(-1,1),randomfloatrange(-1,1),.5))*1000;
trace1 = BulletTrace( (level.player.origin+(0,0,12)), level.player.origin+(0,0,12)+tracedir, false, undefined);
hitdist1 = distance(level.player.origin,trace1["position"]);
vdot = vectordot((0,0,-1),vectornormalize(trace["normal"]));
if(hitdist1<450 && vdot>.75)
{
playfx(getfx(fxid),trace1["position"]);
}
}
}
}
to1 delete();
}
fx_bombshakes_physics_jitter(jitter_loc, f_shakeduration, f_shakescale)
{
jitterTimer = 0;
while(jitterTimer < f_shakeduration)
{
physicsJitter (jitter_loc, 1000, 250, 0, f_shakescale);
jitterTimer += 0.1;
wait 0.1;
}
}
spawn_exp_tendril(origin1,angles1,fxid)
{
mis = spawn_tag_origin();
mis.origin = origin1;
mis.angles = angles1;
fxtend = PlayFXOnTag( getfx( fxid ), mis, "tag_origin" );
impulse = 500 + randomfloat(1500);
lifetime = 10 + randomint(20);
offset = 200;
vectorUp = vectornormalize(anglestoforward(angles1));
vectorFor = vectornormalize(randomvector(2));
mis.origin += offset * (vectorFor[0],vectorFor[1],0);
randomConeAngle = randomfloat(75);
coneAngle = min(1.0,max(0.0, randomConeAngle / 90.0));
finalVector = vectornormalize(vectorUp * (1-coneAngle) + (vectorFor[0],vectorFor[1],0) * coneAngle);
currVel = finalVector * impulse * .05;
gravity = (0,0,-1200) * .05 * .05;
for(i=0;i<lifetime;i++)
{
mis.origin += currVel;
currVel += gravity;
level waitframe();
}
stopfxontag( getfx( fxid ), mis, "tag_origin" );
mis delete();
}
spawn_tendril(origin1,angles1,fxid,f_impulse_min,f_impulse_max,f_lifetime_min,f_lifetime_max,f_offset,f_coneAngle,f_gravity)
{
mis = spawn_tag_origin();
mis.origin = origin1;
mis.angles = angles1;
fxtend = PlayFXOnTag( getfx( fxid ), mis, "tag_origin" );
impulse = f_impulse_min + randomfloat(f_impulse_max-f_impulse_min);
lifetime = f_lifetime_min + randomint(f_lifetime_max-f_lifetime_min);
offset = f_offset;
vectorUp = vectornormalize(anglestoforward(angles1));
vectorFor = vectornormalize(randomvector(2));
mis.origin += offset * (vectorFor[0],vectorFor[1],0);
randomConeAngle = randomfloat(f_coneAngle);
coneAngle = min(1.0,max(0.0, randomConeAngle / 90.0));
finalVector = vectornormalize(vectorUp * (1-coneAngle) + (vectorFor[0],vectorFor[1],0) * coneAngle);
currVel = finalVector * impulse * .05;
gravity = (0,0,(f_gravity) * -1) * .05 * .05;
for(i=0;i<lifetime;i++)
{
mis.origin += currVel;
currVel += gravity;
level waitframe();
}
stopfxontag( getfx( fxid ), mis, "tag_origin" );
mis delete();
}
shg_exploder_tendrils(num,fxid)
{
waittillframeend;
waittillframeend;
waittillframeend;
for(;;)
{
level waittill("exploding_" + num);
exploders = GetExploders( num );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
for(j=0;j<6;j++)
{
thread spawn_exp_tendril(ent.v["origin"],ent.v["angles"],fxid);
}
}
}
}
}
shg_spawn_tendrils(num,fxid,num_tend,f_impulse_min,f_impulse_max,f_lifetime_min,f_lifetime_max,f_offset,f_coneAngle,f_gravity)
{
waittillframeend;
waittillframeend;
waittillframeend;
for(;;)
{
level waittill("exploding_" + num);
exploders = GetExploders( num );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if (!isdefined(ent.v["origin"])) continue;
for(j=0;j<int(num_tend);j++)
{
thread spawn_tendril(ent.v["origin"],ent.v["angles"],fxid,f_impulse_min,f_impulse_max,f_lifetime_min,f_lifetime_max,f_offset,f_coneAngle,f_gravity);
}
}
}
}
}
check_zkey_press()
{
if(level.player buttonPressed("z")==true) return true;
else return false;
}
convertOneShot()
{
}
vision_zone_watcherb(visionSet,flag,blendtime,visionSet_exit)
{
waittillframeend;
flag_init(flag);
ent = spawnStruct();
if ( !isdefined( level.g_visionvols ) )
{
level.g_visionvols = [];
level.g_visionexit = getdvar("vision_set_current");
if(level.g_visionexit == "") level.g_visionexit = "default";
level.g_visiondefault = level.g_visionexit;
level.g_visionblend = 1.0;
if(!flag_exist("start_vision_watcher_manager"))
{
flag_init("vision_watcher_changed");
}
level thread vision_zone_manager();
}
if(visionSet_exit==undefined) visionSet_exit = level.g_visiondefault;
ent.v["vision_set"]=visionSet;
ent.v["vision_set_exit"]=visionSet_exit;
ent.v["blendtime"] = blendtime;
ent.v["active"] = 0;
ent.v["prime"] = 0;
ent.v["flag"] = flag;
level.g_visionvols[level.g_visionvols.size] = ent;
for(;;)
{
flag_wait(flag);
if(ent.v["active"]==0)
{
for(i=0;i<level.g_visionvols.size;i++)
{
level.g_visionvols[i].v["prime"]=0;
}
ent.v["prime"]=1;
}
ent.v["active"]=1;
level.g_visionblend = blendtime;
flag_set("vision_watcher_changed");
wait(blendtime);
flag_waitopen(flag);
ent.v["prime"]=0;
ent.v["active"]=0;
level.g_visionexit = ent.v["vision_set_exit"];
level.g_visionblend = blendtime;
flag_set("vision_watcher_changed");
wait(blendtime);
}
}
vision_zone_watcher(visionSet,flag,blendtime)
{
flag_init(flag);
visionSet_exit = getdvar("vision_set_current");
for(;;)
{
flag_wait(flag);
visionsetnaked(visionSet,blendtime);
wait(1.0);
flag_waitopen(flag);
visionsetnaked(visionSet_exit,blendtime);
wait(1.0);
}
}
vision_zone_manager()
{
while(1)
{
flag_wait("vision_watcher_changed");
currprime = -1;
active = -1;
waittime = 0.0;
for(i=0;i<level.g_visionvols.size;i++)
{
if(level.g_visionvols[i].v["prime"]==1)
{
curr_active = getdvar("vision_set_current");
if(curr_active != level.g_visionvols[i].v["vision_set"]) vision_set_fog_changes(level.g_visionvols[i].v["vision_set"],level.g_visionblend);
currprime = i;
}
if(level.g_visionvols[i].v["active"]==1)
{
active = 1;
}
}
for(i=0;i<level.g_visionvols.size;i++)
{
if(level.g_visionvols[i].v["active"]==1 && currprime == -1)
{
vision_set_fog_changes(level.g_visionvols[i].v["vision_set"],level.g_visionvols[i].v["blendtime"]);
level.g_visionvols[i].v["prime"]=1;
currprime = i;
i=100000;
flag_clear("vision_watcher_changed");
wait(level.g_visionblend);
continue;
}
}
if(active!=1) vision_set_fog_changes(level.g_visionexit,level.g_visionblend);
flag_clear("vision_watcher_changed");
wait(level.g_visionblend);
}
}
fx_zone_watcher(num,flag,flag2,off_flag)
{
assert(isdefined(flag));
flag_init(flag);
flag_init("fx_zone_" + num + "_active");
if(isDefined(flag2))
{
flag_init(flag2);
}
if(isdefined(off_flag))
{
if(!flag_exist(off_flag)) flag_init(off_flag);
}
level waitframe();
if(isdefined(off_flag))
{
thread fx_zone_watcher_either_off_killthread(num,off_flag,flag,flag2);
}
thread fx_zone_watcher_either(num,flag,flag2);
}
fx_zone_watcher_both(num,flag,flag2)
{
assert(isdefined(flag));
flag_init(flag);
flag_init("fx_zone_" + num + "_active");
if(isDefined(flag2))
{
flag_init(flag2);
}
level waitframe();
thread fx_zone_watcher_all(num,flag,flag2);
}
flag_waitopen_both( msg, msg2 )
{
while ( flag( msg ) || flag(msg2) )
level waittill_either( msg, msg2 );
}
send_activate_zone_msg( num )
{
level notify("fx_zone_" + num + "_activating");
flag_set("fx_zone_" + num + "_active");
}
send_deactivate_zone_msg( num )
{
level notify("fx_zone_" + num + "_deactivating");
flag_clear("fx_zone_" + num + "_active");
}
fx_zone_watcher_either(num,flag,flag2)
{
for(;;)
{
if(!isdefined(flag2))
flag2 = flag;
flag_wait_either(flag,flag2);
send_activate_zone_msg( num );
exploder(num);
flag_waitopen_both(flag,flag2);
send_deactivate_zone_msg( num );
PauseExploders( num );
wait(2.0);
}
}
fx_zone_watcher_either_off_killthread(num,off_flag,flag,flag2)
{
for(;;)
{
if(!isdefined(flag2))
flag2 = flag;
flag_wait(off_flag);
{
send_deactivate_zone_msg( num );
PauseExploders( num );
}
send_deactivate_zone_msg( num );
flag_waitopen(off_flag);
if(flag(flag)||flag(flag2))
{
send_activate_zone_msg( num );
exploder(num);
}
}
}
fx_zone_watcher_all(num,flag,flag2)
{
for(;;)
{
if(!isdefined(flag2))
flag2 = flag;
flag_wait_all(flag,flag2);
send_activate_zone_msg( num );
exploder(num);
flag_waitopen_both(flag,flag2);
send_deactivate_zone_msg( num );
PauseExploders( num );
wait(2.0);
}
}
fx_zone_watcher_waitopen(num,flag)
{
if(!isdefined(flag)) flag_init(flag);
flag_init("fx_zone_" + num + "_active");
level waitframe();
for(;;)
{
wait(.1);
flag_waitopen(flag);
send_activate_zone_msg( num );
exploder(num);
flag_wait(flag);
send_deactivate_zone_msg( num );
PauseExploders( num );
wait(2.0);
}
}
kill_exploder(num)
{
PauseExploders( num );
}
kill_oneshot(fxid)
{
exploders = GetEntsByFXID( fxid );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if ( ent.v[ "type" ] == "exploder" )
continue;
ent pauseEffect();
}
}
}
fx_zone_watcher_late(num,flag)
{
flag_init("fx_zone_" + num + "_active");
for(;;)
{
flag_wait(flag);
send_activate_zone_msg( num );
exploder(num);
flag_waitopen(flag);
send_deactivate_zone_msg( num );
exploders = GetExploders( num );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
ent pauseEffect();
}
}
wait(2.0);
}
}
get_exploder_ent(num)
{
returnEnt = undefined;
exploders = GetExploders( num );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
returnEnt = ent;
}
}
return returnEnt;
}
get_exploder_entarray(num)
{
returnEnt = [];
exploders = GetExploders( num );
if (isdefined(exploders))
{
returnEnt = exploders;
}
return returnEnt;
}
fx_spot_lens_flare_tag(fxid)
{
playerAng = level.player getplayerangles();
eye = vectornormalize(anglestoforward(playerAng));
}
fx_spot_lens_flare_dir(fxid,dir,dist)
{
if(!flag_exist("fx_spot_flare_kill")) flag_init("fx_spot_flare_kill");
if(!isdefined(dir)) dir = (-90,0,0);
if(!isdefined(dist)) dist = 10000;
ent = spawn_tag_origin();
playerOrg = level.player.origin;
playerAng = level.player getplayerangles();
dir_vector = vectornormalize(anglestoforward(dir * -1));
flareOrg = dir_vector * -1 * dist + playerOrg;
ent.origin = flareOrg;
eye = vectornormalize(anglestoforward(playerAng));
dot_ratio = min(1,max(0.001,vectordot(eye,(dir_vector * -1))));
dot_ratio /=dot_ratio;
newdir_vector = vectornormalize(eye * (dot_ratio) + dir_vector *2);
offset_extra = vectornormalize(newdir_vector-dir_vector) * (dot_ratio);
newdir = vectortoangles(vectornormalize(newdir_vector+offset_extra));
ent.angles = newdir;
playfxontag(getfx(fxid),ent,"tag_origin");
while(!flag("fx_spot_flare_kill"))
{
playerOrg = level.player.origin;
playerAng = level.player getplayerangles();
dir_vector = vectornormalize(anglestoforward(dir));
flareOrg = dir_vector * dist + playerOrg;
ent.origin = flareOrg;
eye = vectornormalize(anglestoforward(playerAng));
dot_ratio = min(1.0,max(0.001,vectordot(eye,(dir_vector ))));
dot_ratio = dot_ratio * dot_ratio * dot_ratio * dot_ratio;
dot_ratio = 1.0-dot_ratio;
newdir_vector = vectornormalize(eye * (dot_ratio) + dir_vector *2);
offset_extra = vectornormalize(newdir_vector-dir_vector) * (dot_ratio);
newdir = vectortoangles(vectornormalize(newdir_vector+offset_extra *2));
ent.angles = newdir;
level waitframe();
}
ent delete();
stopfxontag(getfx(fxid),ent,"tag_origin");
}
get_exploder_pos(num_start,num_end,fxid)
{
}
create_exploders_fromlist()
{
return 0;
}
get_fx_chain(name,chainset_name,chainset_override)
{
chain = [];
if(!isdefined(chainset_name)) chainset_name = "default";
chain_sets = spawnstruct();
chain_sets.v["default"] = spawnstruct();
chain_sets.v["default"].v["l_arm"] = ["j_shoulder_le","j_elbow_le","j_wrist_le"];
chain_sets.v["default"].v["r_arm"] = ["j_shoulder_ri","j_elbow_ri","j_wrist_ri"];
chain_sets.v["default"].v["l_leg"] = ["j_hip_le","j_knee_le","j_ankle_le"];
chain_sets.v["default"].v["r_leg"] = ["j_hip_ri","j_knee_ri","j_ankle_ri"];
chain_sets.v["default"].v["torso"] = ["j_mainroot","j_spine4","j_neck"];
chain_sets.v["default"].v["head"] = ["j_neck","j_head"];
if(isdefined(chainset_override))
{
o_name = "override";
if(isdefined(chainset_override.v["name"])) o_name = chainset_override.v["name"];
chain_sets.v[o_name] = chainset_override;
}
foreach(currbone in chain_sets.v[chainset_name].v[name])
{
chain[chain.size]=currbone;
}
return chain;
}
setup_fx_chain(chain_ent)
{
if(!isdefined(chain_ent.v["ent"])) return 1;
if(isdefined(chain_ent.v["chain"])) chain_ent.v["bones"] = get_fx_chain(chain_ent.v["chain"],chain_ent.v["chainset_name"],chain_ent.v["chainset_override"]);
else return 1;
chain_ent.v["tags"] = [];
chain_ent.v["tag_lens"] = [];
for(i=0;i<chain_ent.v["bones"].size-1;i++)
{
boneposA = chain_ent.v["ent"] gettagorigin(chain_ent.v["bones"][i]);
boneangA = chain_ent.v["ent"] gettagangles(chain_ent.v["bones"][i]);
boneposB = chain_ent.v["ent"] gettagorigin(chain_ent.v["bones"][i+1]);
if(isdefined(boneposA)&&isdefined(boneposB))
{
bone_vector = boneposB - boneposA;
bone_len = length(bone_vector);
curr_tag = spawn_tag_origin();
curr_tag.origin = boneposA;
curr_tag.angles = vectortoangles(bone_vector);
curr_tag linkto(chain_ent.v["ent"],chain_ent.v["bones"][i]);
chain_ent.v["tags"][chain_ent.v["tags"].size] = curr_tag;
chain_ent.v["tag_lens"][chain_ent.v["tag_lens"].size] = bone_len;
}
}
}
play_fx_on_chain(chain_ent)
{
level endon(chain_ent.v["kill_notify"]);
for(;;)
{
for(i=0;i<chain_ent.v["tags"].size;i++)
{
curr_tag = chain_ent.v["tags"][i];
curr_len = chain_ent.v["tag_lens"][i];
fx_dir = anglestoforward(curr_tag.angles);
fxorigin = curr_tag.origin + fx_dir * curr_len * randomfloat(1.0);
playfx(chain_ent.v["fx"],fxorigin,fx_dir,anglestoup(curr_tag.angles));
}
wait(chain_ent.v["looptime"]);
}
}
kill_fx_on_chain(chain_ent)
{
level waittill(chain_ent.v["kill_notify"]);
print("message received");
for(i=0;i<chain_ent.v["tags"].size;i++)
{
chain_ent.v["tags"][i] delete();
}
chain_ent.v["tags"] = [];
}
play_fx_on_actor(inArgs)
{
ent = inArgs.v["ent"];
fx = inArgs.v["fx"];
chain = inArgs.v["chain"];
looptime = inArgs.v["looptime"];
chainset_name = inArgs.v["chainset_name"];
chainset_override = inArgs.v["chainset_override"];
assertEx(isdefined(ent),"There is no entity defined on play_fx_on_actor call");
if(!isdefined(ent)) return undefined;
assertEx(isdefined(fx),"There is no entity defined on play_fx_on_actor call");
if(!isdefined(fx)) return undefined;
if(!isdefined(chain)) chain = "all";
if(!isdefined(looptime)) looptime = 1.00;
if(!isdefined(chainset_name)) chainset_name = "default";
if(!isdefined(chainset_override)) chainset_override = undefined;
chains = [];
if(chain=="all")
{
chains[chains.size]="head";
chains[chains.size]="r_arm";
chains[chains.size]="l_arm";
chains[chains.size]="r_leg";
chains[chains.size]="l_leg";
chains[chains.size]="torso";
}
else
{
chains[0] = chain;
}
return_notify = (ent.model+"kill_fx_onactor");
chain_ents = [];
foreach(curr_chain in chains)
{
curr_chain_ent = spawnstruct();
curr_chain_ent.v["ent"]=ent;
curr_chain_ent.v["chain"]=curr_chain;
curr_chain_ent.v["fx"]=fx;
curr_chain_ent.v["looptime"]=looptime;
curr_chain_ent.v["kill_notify"] = return_notify;
curr_chain_ent.v["chainset_name"] = chainset_name;
curr_chain_ent.v["chainset_override"] = chainset_override;
setup_fx_chain(curr_chain_ent);
thread play_fx_on_chain(curr_chain_ent);
thread kill_fx_on_chain(curr_chain_ent);
chain_ents[chain_ents.size] = curr_chain_ent;
}
return return_notify;
}

