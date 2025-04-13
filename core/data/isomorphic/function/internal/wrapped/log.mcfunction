### Description:
# This will emit a generic log for an isomorphic datapack.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:<int>,datapack:<string>,message:<text_component>}}
###

# Runs save_log subroutine
execute if data storage isomorphic:config {logging:{save:true}} run function isomorphic:internal/subroutine/save_log

# Returns 1 if we don't want to emit the log due to the config definition.
execute unless predicate isomorphic:logging/can_emit run return 1

# Emits the message according to the level.
function isomorphic:internal/subroutine/emit_tellraw_by_level with storage isomorphic:temp local.arguments

# Will attempt to dump on abort or above messages.
execute if predicate isomorphic:logging/is_abort_log if data storage isomorphic:config {diagnostics:{dump_on_abort:true}} run function isomorphic:api/dump
return 0