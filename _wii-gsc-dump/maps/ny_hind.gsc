#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_common;
CONST_MPHTOIPS = 17.6;
clear_path_type()
{
if (isdefined(self.curpathtype))
return;
self endon("death");
self.curpathtype = "none";
while (true)
{
self waittill("reached_dynamic_path_end");
if (self.curpathtype == "smooth")
self.lastpathnode = self.curNode;
else if (self.curpathtype == "normal")
self.lastpathnode = self.currentNode;
else
self.lastpathnode = undefined;
self.curpathtype="none";
}
}
get_lookahead_point( prvnode, curnode, nxtnode, lookahead)
{
pathdist = 0;
pathlen = 0;
prvpoint = self.origin;
speed = self Vehicle_GetSpeed() * CONST_MPHTOIPS;
if (!isdefined(prvnode))
{
pathdist = 0;
deltapath = curnode.origin - self.origin;
pathlen = Length(deltapath);
deltapath = VectorNormalize(deltapath);
}
else
{
prvpoint = prvnode.origin;
origin = self.origin;
deltapath = curnode.origin - prvnode.origin;
pathlen = Length(deltapath);
deltapath = VectorNormalize(deltapath);
deltaorigin = origin - prvnode.origin;
pathdist = VectorDot(deltapath, deltaorigin);
if (pathdist < 0)
pathdist = 0;
}
lookaheadlen = speed*lookahead;
pathdist += lookaheadlen;
lookaheadpoint = prvpoint + pathdist*deltapath;
while (pathdist >= pathlen)
{
pathdist -= pathlen;
if (!isdefined(nxtnode))
{
lookaheadpoint = curnode.origin;
pathdist = 0;
}
else
{
deltanext = nxtnode.origin - curnode.origin;
pathlen = Length(deltanext);
if (pathdist < pathlen)
{
deltanext = pathdist * VectorNormalize(deltanext);
lookaheadpoint = curnode.origin + deltanext;
}
else
{
prvnode = curnode;
curnode = nxtnode;
if (isdefined(nxtnode.target))
{
nxtnode = getstruct(nxtnode.target, "targetname");
}
else
{
nxtnode = undefined;
}
}
}
}
return lookaheadpoint;
}
smooth_vehicle_path_node_reached( nextpoint )
{
if ( IsDefined( nextpoint.script_prefab_exploder ) )
{
nextpoint.script_exploder = nextpoint.script_prefab_exploder;
nextpoint.script_prefab_exploder = undefined;
}
if ( IsDefined( nextpoint.script_exploder ) )
{
delay = nextpoint.script_exploder_delay;
if ( IsDefined( delay ) )
{
level delayThread( delay, ::exploder, nextpoint.script_exploder );
}
else
{
level exploder( nextpoint.script_exploder );
}
}
if ( IsDefined( nextpoint.script_flag_set ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_set ] = true;
self notify( "vehicle_flag_arrived", nextpoint.script_flag_set );
flag_set( nextpoint.script_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_set ) )
{
self ent_flag_set( nextpoint.script_ent_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_clear ) )
{
self ent_flag_clear( nextpoint.script_ent_flag_clear );
}
if ( IsDefined( nextpoint.script_flag_clear ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_clear ] = false;
flag_clear( nextpoint.script_flag_clear );
}
if ( IsDefined( nextpoint.script_noteworthy ) )
{
if ( nextpoint.script_noteworthy == "kill" )
self force_kill();
if ( nextpoint.script_noteworthy == "godon" )
self godon();
if ( nextpoint.script_noteworthy == "godoff" )
self godoff();
if ( nextpoint.script_noteworthy == "deleteme" )
{
level thread deleteent( self );
return;
}
}
if ( IsDefined( nextpoint.script_crashtypeoverride ) )
self.script_crashtypeoverride = nextpoint.script_crashtypeoverride;
if ( IsDefined( nextpoint.script_badplace ) )
self.script_badplace = nextpoint.script_badplace;
if ( IsDefined( nextpoint.script_turretmg ) )
self.script_turretmg = nextpoint.script_turretmg;
if ( IsDefined( nextpoint.script_team ) )
self.script_team = nextpoint.script_team;
if ( IsDefined( nextpoint.script_turningdir ) )
self notify( "turning", nextpoint.script_turningdir );
if ( IsDefined( nextpoint.script_deathroll ) )
if ( nextpoint.script_deathroll == 0 )
self thread deathrolloff();
else
self thread deathrollon();
}
smooth_vehicle_path_set_lookahead( lookahead )
{
self.lookahead = lookahead;
}
smooth_vehicle_path_set_override_speed( speed, accel, decel )
{
if ((speed > self.veh_speed) && (speed < accel))
accel = speed;
self.override_speed = speed;
self.override_accel = accel;
self.override_decel = decel;
self Vehicle_SetSpeed( speed, accel, decel );
}
smooth_vehicle_path_clear_override_speed()
{
if (isdefined(self.override_speed))
self.override_speed = undefined;
if (isdefined(self.override_accel))
self.override_accel = undefined;
if (isdefined(self.override_decel))
self.override_decel = undefined;
}
smooth_vehicle_path_SetTargetYaw( yaw )
{
while (yaw < -180)
yaw += 360;
while (yaw > 180)
yaw -= 360;
self.targetyawset = yaw;
self SetTargetYaw(yaw);
}
smooth_vehicle_path_ClearTargetYaw( )
{
self.targetyawset = undefined;
self ClearTargetYaw();
}
smooth_vehicle_debug_node( )
{
}
ny_start_heli_path( startnode, lookahead, radius)
{
self.curpathstart = startnode.targetname;
if (test_if_smooth_path( startnode ))
{
self thread clear_path_type();
self thread smooth_vehicle_path( startnode, lookahead, radius );
self.curpathtype = "smooth";
}
else
{
self thread clear_path_type();
self thread vehicle_paths( startnode );
self.curpathtype = "normal";
}
}
test_if_smooth_path(startnode)
{
if (isdefined(startnode.spawnflags) && (startnode.spawnflags & 2))
return true;
return false;
}
smooth_vehicle_setgoal( tgt_point, endOfPath )
{
self.curnode_set = self.curnode;
if ( IsDefined( self.prvnode ) )
{
airResistance = self.prvnode.script_airresistance;
speed = self.prvnode.speed;
accel = self.prvnode.script_accel;
decel = self.prvnode.script_decel;
}
else
{
airResistance = undefined;
speed = undefined;
accel = undefined;
decel = undefined;
}
if (isdefined(self.override_speed))
{
speed = self.override_speed;
accel = self.override_accel;
decel = self.override_decel;
}
if (IsDefined( self.curnode.lookahead) )
lookahead = self.curnode.lookahead;
if (IsDefined( self.curnode.radius) )
radius = self.curnode.radius;
stopnode = IsDefined( self.curnode.script_stopnode ) && self.curnode.script_stopnode;
unload = IsDefined( self.curnode.script_unload );
flag_wait = ( IsDefined( self.curnode.script_flag_wait ) && !flag( self.curnode.script_flag_wait ) );
hasDelay = IsDefined( self.curnode.script_delay );
if ( IsDefined( self.curnode.angles ) )
yaw = self.curnode.angles[ 1 ];
else
yaw = 0;
self Vehicle_HeliSetAI( tgt_point, speed, accel, decel, self.curnode.script_goalyaw, self.curnode.script_anglevehicle, yaw, airResistance, hasDelay, stopnode, unload, flag_wait, endOfPath );
self.smooth_tgt_point = tgt_point;
self.smooth_speed = speed;
self.smooth_accel = accel;
self.smooth_decel = decel;
if ((!isdefined(self.curnode.script_goalyaw) || !self.curnode.script_goalyaw) && isdefined(self.targetyawset))
{
self SetTargetYaw( self.targetyawset );
}
}
smooth_vehicle_path( node, lookahead, radius )
{
self notify("newpath");
self endon("newpath");
self smooth_vehicle_path_clear_override_speed();
self.lookahead = lookahead;
self.prvnode = undefined;
self.curnode = node;
self.nxtnode = undefined;
if (isdefined(self.curnode.target))
self.nxtnode = getstruct(self.curnode.target, "targetname");
while (isdefined(self.curnode))
{
curpoint = self.curnode.origin;
if ( IsDefined( self.heliheightoverride ) )
curpoint = ( curpoint[0], curpoint[1], self.heliheightoverride );
dist = Length(curpoint - self.origin);
tgt_point = get_lookahead_point( self.prvnode, self.curnode, self.nxtnode, self.lookahead);
if ( IsDefined( self.heliheightoverride ) )
tgt_point = ( tgt_point[0], tgt_point[1], self.heliheightoverride );
org2tgt = self.origin - tgt_point;
org2tgt_n = VectorNormalize(org2tgt);
org2cur = self.origin - curpoint;
if (!isdefined(self.nxtnode))
dist2cur = radius + 10;
else
dist2cur = VectorDot(org2tgt_n, org2cur);
if ((dist < radius) || (dist2cur < radius))
{
smooth_vehicle_path_node_reached( self.curnode );
if (!isdefined(self.nxtnode) && isdefined(self.curnode))
{
self smooth_vehicle_setgoal( self.curnode.origin, 1 );
}
self.prvnode = self.curnode;
self.curnode = self.nxtnode;
self.nxtnode = undefined;
if (isdefined(self.curnode) && isdefined(self.curnode.target))
self.nxtnode = getstruct(self.curnode.target, "targetname");
}
else
{
self smooth_vehicle_setgoal( tgt_point, 0 );
wait 0.05;
}
}
self StopCapturePath();
if ( IsDefined(self.prvnode) && IsDefined( self.prvnode.script_land ) )
self thread vehicle_landvehicle();
self notify( "reached_dynamic_path_end" );
if ( IsDefined(self.prvnode) && IsDefined( self.prvnode.script_vehicle_selfremove ) )
self Delete();
}
smooth_vehicle_show_switch( startnode, newnode, forward )
{
}
smooth_vehicle_switch_path( startnode, lookahead, radius, force_smooth, force_normal )
{
node = startnode;
if (isdefined(startnode.target))
{
node = getstruct(startnode.target, "targetname");
if (!isdefined(node))
node = startnode;
}
nodes[0] = startnode;
while (node != startnode)
{
nodes[nodes.size] = node;
if (isdefined(node.target))
{
node = getstruct(node.target, "targetname");
if (!isdefined(node))
break;
}
else
break;
}
origin = self.origin;
if (!isdefined(self.curpathtype))
{
forward = self Vehicle_GetVelocity();
}
else if ((self.curpathtype == "normal") && (isdefined(self.currentnode)))
{
forward = self.origin - self.currentnode.origin;
}
else if ((self.curpathtype == "smooth") && (isdefined(self.curnode)))
{
forward = self.origin - self.curnode.origin;
}
else
forward = self Vehicle_GetVelocity();
forward = VectorNormalize(forward);
bestnode = undefined;
bestwdist = 1000000;
closestnode = undefined;
closestdist = 1000000;
foreach (node in nodes)
{
org2node = node.origin - origin;
org2node_n = VectorNormalize(org2node);
dp = VectorDot(org2node_n,forward);
dist = Length(org2node);
if (dp > 0)
{
wdist = (1 - dp) * dist;
if (wdist < bestwdist)
{
bestnode = node;
bestwdist = wdist;
}
}
if (dist < closestdist)
{
closestnode = node;
closestdist = dist;
}
}
if (!isdefined(bestnode))
bestnode = closestnode;
self.curpathstart = bestnode.targetname;
if (isdefined(force_smooth) || (test_if_smooth_path( startnode ) && !isdefined(force_normal)))
{
self thread clear_path_type();
self thread smooth_vehicle_path( bestnode, lookahead, radius );
self.curpathtype = "smooth-s";
}
else
{
self thread clear_path_type();
self thread vehicle_paths( bestnode );
self.curpathtype = "normal-s";
}
}
adjust_follow_offset_angoff( offset, angoff, t )
{
assert(isdefined(self.follow_offset));
self notify("stop_adjust");
self endon("stop_adjust");
self endon("death");
dt = 1;
count = 0;
if (t > 0)
{
dt = 0.05/t;
count = int(t/0.05);
}
doff = dt*(offset - self.follow_offset);
dang = dt*(angoff - self.follow_angoff);
while (count > 0)
{
self.follow_offset += doff;
self.follow_angoff += dang;
count--;
wait 0.05;
}
self.follow_offset = offset;
self.follow_angoff = angoff;
}
set_useVelAng( whoseVel )
{
self.follow_useVelAng = whoseVel;
}
follow_enemy_vehicle( enemy, offset, angoff, useVelAng )
{
self notify("newpath");
self endon("newpath");
enemy endon("death");
self endon("death");
self thread clear_path_type();
self.curpathtype = "follow";
self.curpathstart = undefined;
predicttime = 0.0;
self.follow_offset = offset;
self.follow_angoff = angoff;
self.follow_useVelAng = useVelAng;
while (true)
{
offset = self.follow_offset;
tgtpos = enemy.origin;
tgtvel = enemy Vehicle_GetVelocity();
ourvel = self Vehicle_GetVelocity();
tgtspeed = enemy Vehicle_GetSpeed();
tgtforward = VectorNormalize(tgtvel);
tgtright = VectorCross((0, 0, 1), tgtforward);
tgtright = VectorNormalize(tgtright);
tgtup = VectorCross( tgtforward, tgtright );
tgtup = VectorNormalize( tgtup );
goal = tgtpos + offset[0] * tgtforward + offset[1] * tgtright + offset[2] * tgtup;
err = goal - self.origin;
errdist = Length(err);
dist = Length(self.origin - tgtpos);
idealdist = Length(offset);
offdir = VectorNormalize(offset);
dp = VectorDot(tgtforward,err);
speed = tgtspeed;
if (dp > 0)
{
threshdist = 1.5*Length(offset);
basespeedup = 1.0;
if (errdist > threshdist)
{
speed = (1.0 + basespeedup) * speed;
accel = speed;
decel = speed;
}
else
{
scale = 1.0 + (basespeedup*errdist/threshdist);
speed = scale * speed;
accel = 0.75 * speed;
decel = 0.75 * speed;
}
}
else
{
threshdist = Length(offset);
if (offset[0] <= 0)
baseslowdown= 0.95;
else
baseslowdown= 0.75;
if (errdist > threshdist)
{
scale = baseslowdown*threshdist/errdist;
speed = scale * speed;
accel = speed;
decel = speed;
}
else
{
errscale = 1.0 - errdist/threshdist;
speed = (baseslowdown + errscale*(1-baseslowdown)) * speed;
accel = 0.75 * speed;
decel = 0.75 * speed;
}
}
predicttime = 1.0;
self Vehicle_SetSpeed( speed, accel, decel );
if (isdefined(self.follow_useVelAng) && (self.follow_useVelAng > 0))
{
if (self.follow_useVelAng == 1)
velocity = self Vehicle_GetVelocity();
else
velocity = enemy Vehicle_GetVelocity();
mag = Length(velocity);
if (mag > 24)
{
forwyaw = VectorToYaw( velocity );
self smooth_vehicle_path_SetTargetYaw ( forwyaw + self.follow_angoff );
}
}
else
{
playeryaw = VectorToYaw ( enemy.origin - (level.player GetEye()) );
self smooth_vehicle_path_SetTargetYaw ( playeryaw + self.follow_angoff );
}
pgoal = goal + predicttime*tgtvel;
self SetVehGoalPos( pgoal );
wait 0.05;
}
}
follow_enemy_vehicle_thats_using_smoothpath( enemy, offset, angoff, useVelAng )
{
self notify("newpath");
self endon("newpath");
enemy endon("death");
self endon("death");
self thread clear_path_type();
self.curpathtype = "followsm";
self.curpathstart = undefined;
self.follow_offset = offset;
self.follow_angoff = angoff;
self.follow_useVelAng = useVelAng;
while (true)
{
offset = self.follow_offset;
tgtpos = enemy.origin;
tgtvel = enemy Vehicle_GetVelocity();
tgtspeed = enemy Vehicle_GetSpeed();
tgtforward = VectorNormalize(tgtvel);
tgtright = VectorCross((0, 0, 1), tgtforward);
tgtright = VectorNormalize(tgtright);
tgtup = VectorCross( tgtforward, tgtright );
tgtup = VectorNormalize( tgtup );
tgt_point = enemy.smooth_tgt_point;
tgt_speed =	enemy.smooth_speed;
tgt_accel =	enemy.smooth_accel;
tgt_decel =	enemy.smooth_decel;
curoff = offset[0] * tgtforward + offset[1] * tgtright + offset[2] * tgtup;
tgt_goal = tgt_point + curoff;
goal = tgtpos + curoff;
err = goal - self.origin;
errdist = Length(err);
dist = Length(self.origin - tgtpos);
idealdist = Length(offset);
offdir = VectorNormalize(offset);
dp = VectorDot(tgtforward,err);
speed = tgtspeed;
if (dp > 0)
{
threshdist = 1.5*Length(offset);
basespeedup = 1.0;
if (errdist > threshdist)
{
speed = (1.0 + basespeedup) * speed;
accel = speed;
decel = speed;
}
else
{
scale = 1.0 + (basespeedup*errdist/threshdist);
speed = scale * speed;
accel = 0.75 * speed;
decel = 0.75 * speed;
}
}
else
{
threshdist = Length(offset);
if (offset[0] <= 0)
baseslowdown= 0.95;
else
baseslowdown= 0.75;
if (errdist > threshdist)
{
scale = baseslowdown*threshdist/errdist;
speed = scale * speed;
accel = speed;
decel = speed;
}
else
{
errscale = 1.0 - errdist/threshdist;
speed = (baseslowdown + errscale*(1-baseslowdown)) * speed;
accel = 0.75 * speed;
decel = 0.75 * speed;
}
}
self Vehicle_SetSpeed( speed, speed, speed );
if (isdefined(self.follow_useVelAng) && (self.follow_useVelAng > 0))
{
if (self.follow_useVelAng == 1)
velocity = self Vehicle_GetVelocity();
else
velocity = enemy Vehicle_GetVelocity();
mag = Length(velocity);
if (mag > 24)
{
forwyaw = VectorToYaw( velocity );
self smooth_vehicle_path_SetTargetYaw ( forwyaw + self.follow_angoff );
}
}
else
{
playeryaw = VectorToYaw ( enemy.origin - (level.player GetEye()) );
self smooth_vehicle_path_SetTargetYaw ( playeryaw + self.follow_angoff );
}
self SetVehGoalPos( tgt_goal );
wait 0.05;
}
}
eval_bezier( pts, t)
{
omt = 1-t;
switch(pts[4])
{
case 1:
return pts[0] + t*(pts[3] - pts[0]);
case 3:
omt2 = omt*omt;
omt3 = omt*omt2;
t2 = t*t;
t3 = t*t2;
return omt3*pts[0] + 3*omt2*t*pts[1] + 3*omt*t2*pts[2] + t3*pts[3];
}
}
determine_dir(P0, P3, tangent)
{
tween = P3 - P0;
dist = Length(tween);
dp = VectorDot(VectorNormalize(tween),tangent);
if (dp != 0)
{
len = 0.5*dist/dp;
return len*tangent;
}
else
{
len = 0.5*dist;
return len*tangent;
}
}
bezier_points( origin, prvprvpos, prvnode, curnode, nxtnode)
{
pts[4] = 3;
pts[3] = curnode.origin;
if (isdefined(prvnode))
{
pts[0] = prvnode.origin;
if (isdefined(nxtnode))
{
tangent = VectorNormalize(nxtnode.origin - pts[0]);
pts[2] = pts[3] - determine_dir(pts[0], pts[3], tangent);
if (isdefined(prvprvpos))
{
tangent = VectorNormalize(curnode.origin - prvprvpos);
pts[1] = pts[0] + determine_dir(pts[0], pts[3], tangent);
}
else
{
pts[1] = pts[2];
}
}
else
{
if (isdefined(prvprvpos))
{
tangent = VectorNormalize(curnode.origin - prvprvpos);
pts[1] = pts[0] + determine_dir(pts[0], pts[3], tangent);
pts[2] = pts[1];
}
else
{
pts[4] = 1;
}
}
}
else
{
pts[0] = origin;
if (!isdefined(nxtnode))
{
pts[4] = 1;
}
else
{
tangent = VectorNormalize(nxtnode.origin - pts[0]);
pts[2] = pts[3] - determine_dir(pts[0], pts[3], tangent);
pts[1] = pts[2];
}
}
return pts;
}
bezier_length(pts)
{
if (pts[4] == 1)
dist = Length(pts[3] - pts[0]);
else
{
dist = 0;
step = 0.05;
prvpoint = eval_bezier( pts, 0.0);
for (t=step; t <= 1.0; t += step)
{
curpoint = eval_bezier( pts, t );
dist += Length(curpoint - prvpoint);
prvpoint = curpoint;
}
return dist;
}
}
bezier_vehicle_path( node, lookahead, radius )
{
self endon("newpath");
self thread clear_path_type();
self.curpathtype = "bezier";
self.curpathstart = node.targetname;
self.lookahead = lookahead;
startorigin = self.origin;
self.prvprvpos = undefined;
self.prvnode = undefined;
self.curnode = node;
self.nxtnode = undefined;
if (isdefined(self.curnode.target))
self.nxtnode = getstruct(self.curnode.target, "targetname");
while (isdefined(self.curnode))
{
pts = bezier_points( self.origin, self.prvprvpos, self.prvnode, self.curnode, self.nxtnode);
if ( IsDefined( self.prvnode ) )
{
airResistance = self.prvnode.script_airresistance;
speed = self.prvnode.speed;
accel = self.prvnode.script_accel;
decel = self.prvnode.script_decel;
}
else
{
airResistance = undefined;
speed = undefined;
accel = undefined;
decel = undefined;
}
if (IsDefined( self.curnode.lookahead) )
lookahead = self.curnode.lookahead;
if (IsDefined( self.curnode.radius) )
radius = self.curnode.radius;
stopnode = IsDefined( self.curnode.script_stopnode ) && self.curnode.script_stopnode;
unload = IsDefined( self.curnode.script_unload );
flag_wait = ( IsDefined( self.curnode.script_flag_wait ) && !flag( self.curnode.script_flag_wait ) );
endOfPath = !IsDefined( self.curnode.target );
hasDelay = IsDefined( self.curnode.script_delay );
if ( IsDefined( self.curnode.angles ) )
yaw = self.curnode.angles[ 1 ];
else
yaw = 0;
blength = bezier_length(pts);
dist = 0;
distahead = radius;
prv_point = eval_bezier( pts, 0.0);
cur_point = prv_point;
t=0.0;
while (t < 1.0)
{
dist += Length(cur_point - prv_point);
t = (dist + distahead)/blength;
if (t > 1.0)
t = 1.0;
tgt_point = eval_bezier( pts, t);
self UpdateDebugPath(tgt_point);
self Vehicle_HeliSetAI( tgt_point, speed, accel, decel, self.curnode.script_goalyaw, self.curnode.script_anglevehicle, yaw, airResistance, hasDelay, stopnode, unload, flag_wait, endOfPath );
if (Length(self.origin - prv_point) < radius)
{
cur_point = prv_point;
prv_point = tgt_point;
}
self UpdateCapturePath();
t += 0.05;
wait 0.05;
}
smooth_vehicle_path_node_reached( self.curnode );
if (isdefined(self.prvnode))
self.prvprvpos = self.prvnode.origin;
else
self.prvprvpos = startorigin;
self.prvnode = self.curnode;
self.curnode = self.nxtnode;
self.nxtnode = undefined;
if (isdefined(self.curnode) && isdefined(self.curnode.target))
self.nxtnode = getstruct(self.curnode.target, "targetname");
}
self StopCapturePath();
}
StartCapturePath()
{
}
UpdateCapturePath()
{
}
StopCapturePath()
{
}
DrawCapturePath()
{
}
TrackEntity( bAngles )
{
}
StartDebugPath( bAngles )
{
}
UpdateDebugPath( origin, angles )
{
}
StopDebugPath()
{
}
DrawDebugPath()
{
}
AddDebugPoint( origin, colr )
{
}
DrawDebugPoints()
{
}
DebugHind(debugHealth, debugTrack)
{
}
DebugHindName()
{
self endon("death");
if (!isdefined(self.name))
return;
while (true)
{
origin = self.origin;
offset = ( 0, 0, 60);
Print3d( origin + offset, self.name, (1,1,0.5), 1, 1 );
if (isdefined(self.curpathtype))
{
str = "PT:"+self.curpathtype;
if (isdefined(self.curpathstart))
{
str = str + " - " + self.curpathstart;
if (self.curpathtype == "normal")
{
if (isdefined(self.currentnode) && isdefined(self.currentnode.target))
str = str + " > " + self.currentnode.target;
}
else if (self.curpathtype == "smooth")
{
if (isdefined(self.curnode) && isdefined(self.curnode.target))
str = str + " > " + self.curnode.target;
}
else if (self.curpathtype == "none")
{
if (isdefined(self.lastpathnode) && isdefined(self.lastpathnode.targetname))
str = str + " | " + self.lastpathnode.targetname;
}
}
Print3d( origin - offset, str, (1,1,0.5), 1, 1 );
}
wait 0.05;
}
}
DebugCatchHits()
{
self endon("death");
prvhealth = self.health - self.healthbuffer;
while (self.health > 0)
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
if (isdefined(amount))
{
curhealth = self.health - self.healthbuffer;
self.debug_health_recs[self.debug_health_recs.size] = curhealth;
prvhealth = curhealth;
}
}
}
DebugHindHealth()
{
self endon("death");
self.debug_health_recs = [];
self.debug_health_recs[0] = self.health - self.healthbuffer;
self thread DebugCatchHits();
zscale = 0.1;
while (true)
{
origin = self.origin;
curhealth = self.health - self.healthbuffer;
colr = (0, 1, 0);
if (curhealth < 0)
colr = (1, 1, 0);
line(origin, origin + (0, 0, curhealth*zscale), colr);
for (i=0; i<self.debug_health_recs.size; i++)
{
if (i & 1)
colr = (1,0,0);
else
colr = (0,0,1);
nxthealth = self.debug_health_recs[i];
line(origin + (0, 0, curhealth*zscale), origin + (0, 0, nxthealth*zscale), colr);
curhealth = nxthealth;
}
wait 0.05;
}
}
