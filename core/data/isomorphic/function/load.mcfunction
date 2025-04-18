# We do our resetting of the working areas early.
execute if data storage isomorphic:config {diagnostics:{clear_history_on_reload:true}} run data remove storage isomorphic:temp history
data remove storage isomorphic:temp local
data remove storage isomorphic:global flags
data remove storage isomorphic:global pm

function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:false}}
function isomorphic:api/register {name:"isomorphic",path:"file/IsomorphicCore.zip",dependencies:[]}