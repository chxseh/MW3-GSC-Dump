#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_shg_fx;
ge_CreateEventManager( category, availablecost, classes )
{
assert(!isdefined(level._gameEventManagers) || !isdefined(level._gameEventManagers[category]));
if (!isdefined(level._gameEventManagers))
{
thread _ge_ProcessThread();
}
mgr = spawnstruct();
level._gameEventManagers[category] = mgr;
mgr.availablecost = availablecost;
if (isarray(availablecost))
{
for (i=0; i<availablecost.size; i++)
mgr.currentactivecost[i] = 0;
}
else
mgr.currentactivecost = 0;
mgr.waiting = spawnstruct();
mgr.active = spawnstruct();
mgr.classes = classes;
mgr.index = 0;
}
_ge_CountEvents( list, class )
{
count = 0;
if (isdefined(list) && isdefined(list.head))
{
list = list.head;
while (isdefined(list))
{
if (!isdefined(class) || (list.class == class))
count++;
list = list._next;
}
}
return count;
}
ge_InitDebugging()
{
}
_ge_CanAfford( event, mgr )
{
if (event.priority >= 100)
return true;
if (isarray(mgr.availablecost))
{
assert(isarray(mgr.currentactivecost));
assert(isarray(event.cost));
for (i=0; i<mgr.availablecost.size; i++)
{
assert(isdefined(mgr.currentactivecost[i]));
assert(isdefined(event.cost[i]));
if ((event.cost[i] + mgr.currentactivecost[i]) > mgr.availablecost[i])
return false;
}
}
else
{
assert(!isarray(mgr.currentactivecost));
assert(!isarray(event.cost));
if ((event.cost + mgr.currentactivecost) > mgr.availablecost)
return false;
}
return true;
}
_ge_AddCostToActive( event, mgr )
{
if (isarray(mgr.availablecost))
{
assert(isarray(mgr.currentactivecost));
assert(isarray(event.cost));
for (i=0; i<mgr.availablecost.size; i++)
{
assert(isdefined(mgr.currentactivecost[i]));
assert(isdefined(event.cost[i]));
mgr.currentactivecost[i] += event.cost[i];
}
}
else
{
assert(!isarray(mgr.currentactivecost));
assert(!isarray(event.cost));
mgr.currentactivecost += event.cost;
}
}
_ge_SubtractCostToActive( event, mgr )
{
if (isarray(mgr.availablecost))
{
assert(isarray(mgr.currentactivecost));
assert(isarray(event.cost));
for (i=0; i<mgr.availablecost.size; i++)
{
assert(isdefined(mgr.currentactivecost[i]));
assert(isdefined(event.cost[i]));
mgr.currentactivecost[i] -= event.cost[i];
assert( mgr.currentactivecost[i] >= 0 );
}
}
else
{
assert(!isarray(mgr.currentactivecost));
assert(!isarray(event.cost));
mgr.currentactivecost -= event.cost;
assert( mgr.currentactivecost >= 0 );
}
}
_ge_ProcessManager( category, mgr )
{
if (isdefined(mgr.waiting.head))
{
event = mgr.waiting.head;
if (_ge_CanAfford( event, mgr ))
{
assert(!isdefined(event._prev));
mgr.waiting.head = event._next;
if (isdefined(mgr.waiting.head))
{
mgr.waiting.head._prev = undefined;
}
else
{
mgr.waiting.tail = undefined;
}
event._next = undefined;
if (isdefined(mgr.active.tail))
{
assert(!isdefined(mgr.active.tail._next));
mgr.active.tail._next = event;
event._prev = mgr.active.tail;
mgr.active.tail = event;
}
else
{
mgr.active.head = event;
mgr.active.tail = event;
}
event._active = 1;
_ge_AddCostToActive( event, mgr );
if (isdefined(event.activate_cb))
thread [[ event.activate_cb ]]( event );
}
}
}
_ge_ProcessThread()
{
while (true)
{
if (isdefined(level._gameEventManagers))
{
foreach (category, mgr in level._gameEventManagers)
{
_ge_ProcessManager(category, mgr);
}
}
wait 0.05;
}
}
ge_CreateEvent( cost, priority, class )
{
event = spawnstruct();
event.priority = priority;
event.class = class;
event.cost = cost;
event._active = 0;
return event;
}
ge_AddEvent( category, event)
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
assert(!isarray(mgr.availablecost) || (isarray(event.cost) && (mgr.availablecost.size == event.cost.size)));
assert(isarray(mgr.availablecost) || !isarray(event.cost));
assert(IsString(event.class));
event._mgr = mgr;
event.id = mgr.index;
mgr.index++;
cur = mgr.waiting.head;
prv = undefined;
while (isdefined(cur))
{
if (event.priority > cur.priority)
{
if (isdefined(prv))
{
prv._next = event;
event._prev = prv;
}
else
{
mgr.waiting.head = event;
}
event._next = cur;
cur._prev = event;
break;
}
else
{
prv = cur;
cur = cur._next;
}
}
if (!isdefined(cur))
{
if (isdefined(prv))
{
prv._next = event;
event._prev = prv;
}
else
{
mgr.waiting.head = event;
}
}
if (!isdefined(event._next))
{
mgr.waiting.tail = event;
}
}
_ge_RemoveEvent( list, event )
{
prv = event._prev;
nxt = event._next;
if (isdefined(prv))
{
assert( prv._next == event);
prv._next = nxt;
}
else
{
assert(list.head == event);
list.head = event._next;
}
if (isdefined(nxt))
{
assert( nxt._prev == event);
nxt._prev = prv;
}
else
{
assert(list.tail == event);
list.tail = event._prev;
}
event._prev = undefined;
event._next = undefined;
event._active = -1;
}
_ge_RemoveActiveEvent( mgr, event, call_kill)
{
if (call_kill && isdefined(event.kill_cb))
{
[[event.kill_cb]](event);
}
_ge_SubtractCostToActive( event, mgr );
_ge_RemoveEvent( mgr.active, event );
event notify("killed");
}
_ge_RemoveWaitingEvent( mgr, event, call_cancel)
{
if (call_cancel && isdefined(event.cancel_cb))
{
[[event.cancel_cb]](event);
}
_ge_RemoveEvent( mgr.waiting, event );
}
ge_FlushEvents( category, classes )
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
event = mgr.waiting.head;
while (isdefined(event))
{
nxt = event._next;
if (isarray(classes))
{
foreach (class in classes)
{
if (event.class == class)
{
_ge_RemoveWaitingEvent( mgr, event, true);
break;
}
}
}
else
{
if (event.class == classes)
_ge_RemoveWaitingEvent( mgr, event, true);
}
event = nxt;
}
event = mgr.active.head;
while (isdefined(event))
{
nxt = event._next;
if (isarray(classes))
{
foreach (class in classes)
{
if (event.class == class)
{
_ge_RemoveActiveEvent( mgr, event, true);
break;
}
}
}
else
{
if (event.class == classes)
_ge_RemoveActiveEvent( mgr, event, true);
}
event = nxt;
}
}
ge_EventFinished( event, delay )
{
if (isdefined(delay))
wait delay;
if (!isdefined(event))
return;
if (event._active < 0)
return;
mgr = event._mgr;
assert(isdefined(mgr));
if (event._active)
{
_ge_RemoveActiveEvent( mgr, event, false );
}
else
{
_ge_RemoveWaitingEvent( mgr, event, false );
}
}
ge_FindNextEventByName( event, name )
{
if (isdefined(event))
{
while (isdefined(event))
{
if (isdefined(event.name) && (event.name == name))
break;
event = event._next;
}
}
return event;
}
ge_FindWaitingEventByName( category, name )
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
event = mgr.waiting.head;
return ge_FindNextEventByName( event, name );
}
ge_FindActiveEventByName( category, name )
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
event = mgr.active.head;
return ge_FindNextEventByName( event, name );
}
_ge_CountEventsByName( event, name )
{
count = 0;
if (isdefined(event))
{
while (isdefined(event))
{
if (isdefined(event.name) && (event.name == name))
count++;
event = event._next;
}
}
return count;
}
ge_CountWaitingEventByName( category, name )
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
event = mgr.waiting.head;
return _ge_CountEventsByName( event, name );
}
ge_CountActiveEventByName( category, name )
{
mgr = level._gameEventManagers[category];
assert(isdefined(mgr));
event = mgr.active.head;
return _ge_CountEventsByName( event, name );
}
ge_AddEffect( fxname, lifetime, cost, priority, class )
{
if (!isdefined(lifetime))
lifetime = -1;
event = _ge_AddEffectEvent( cost, priority, class );
event.fxname = fxname;
event.lifetime = lifetime;
return event;
}
_ge_AddEffectEvent( cost, priority, class )
{
if (!isdefined(cost))
cost = 100;
if (!isdefined(priority))
priority = 100;
if (!isdefined(class))
class = 1;
event = ge_CreateEvent( cost, priority, class );
event.activate_cb = ::_ge_ActivateEffect;
event.cancel_cb = ::_ge_CancelEffect;
event.kill_cb = ::_ge_KillEffect;
ge_AddEvent( "fx", event);
return event;
}
_ge_ActivateEffect( event )
{
event endon("killed");
}
_ge_CancelEffect( event )
{
}
_ge_KillEffect( event )
{
}
ge_AddExploder( fxid, lifetime, cost, priority, class )
{
if (!isdefined(lifetime))
lifetime = -1;
event = _ge_AddExploderEvent( cost, priority, class );
event.fxnid = fxid;
event.lifetime = lifetime;
}
_ge_AddExploderEvent( cost, priority, class )
{
if (!isdefined(cost))
cost = 100;
if (!isdefined(priority))
priority = 100;
if (!isdefined(class))
class = 1;
event = ge_CreateEvent( cost, priority, class );
event.activate_cb = ::_ge_ActivateExploder;
event.kill_cb = ::_ge_KillExploder;
ge_AddEvent( "fx", event);
return event;
}
_ge_ActivateExploder( event )
{
assert(isdefined(event.fxid));
event endon("killed");
exploder(event.fxid);
if (isdefined(event.lifetime))
{
if (event.lifetime == 0)
{
ge_EventFinished("fx", event);
}
else if (event.lifetime > 0)
{
wait event.lifetime;
ge_EventFinished("fx", event);
}
}
}
_ge_KillExploder( event )
{
}
ge_AddNotify( category, activate_msg, cancel_msg, kill_msg, cost, priority, class, name )
{
event = ge_CreateEvent( cost, priority, class );
event.activate_msg = activate_msg;
event.cancel_msg = cancel_msg;
event.kill_msg = kill_msg;
event.activate_cb = ::_ge_ActivateNotify;
event.cancel_cb = ::_ge_CancelNotify;
event.kill_cb = ::_ge_KillNotify;
event.name = name;
ge_AddEvent( category, event);
return event;
}
ge_AddNotifyWait( category, activate_msg, cancel_msg, kill_msg, cost, priority, class, name )
{
event = ge_AddNotify( category, activate_msg, cancel_msg, kill_msg, cost, priority, class, name );
event waittill( activate_msg );
return event;
}
_ge_Notify( event, msg )
{
event notify( msg );
if (isdefined(event.ent))
event.ent notify( msg );
}
_ge_ActivateNotify( event )
{
_ge_Notify( event, event.activate_msg );
}
_ge_CancelNotify( event )
{
_ge_Notify( event, event.cancel_msg );
}
_ge_KillNotify( event )
{
_ge_Notify( event, event.kill_msg );
}
ge_AddFxNotify( activate_msg, cancel_msg, kill_msg, cost, priority, class )
{
return ge_AddNotify( "fx", activate_msg, cancel_msg, kill_msg, cost, priority, class );
}
ge_AddFxNotifyWait( activate_msg, cancel_msg, kill_msg, cost, priority, class, name )
{
return ge_AddNotifyWait( "fx", activate_msg, cancel_msg, kill_msg, cost, priority, class, name );
}
ge_AddAlways( category, cost, priority, class )
{
event = ge_CreateEvent( cost, priority, class );
ge_AddEvent( category, event);
}
