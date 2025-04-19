# We do our resetting of the working areas early.
execute if data storage isomorphic:config {diagnostics:{clear_history_on_reload:true}} run data remove storage isomorphic:temp history
execute if data storage isomorphic:config {diagnostics:{clear_dump_on_reload:true}} run data remove storage isomorphic:dump dump
data remove storage isomorphic:temp local
data remove storage isomorphic:global flags
data remove storage isomorphic:global pm
data remove storage isomorphic:global periodic

function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:false}}
function isomorphic:api/register {name:"isomorphic",path:"file/IsomorphicCore.zip",dependencies:[]}

# This will kick off the periodic call loop.
function isomorphic:internal/subroutine/reschedule_periodic_calls