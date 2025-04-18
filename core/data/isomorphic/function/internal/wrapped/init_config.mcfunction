### Description:
# This will reset/instantiate the config.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:<bool>}}
###

# Defaults logging to emit for fatal errors & alerts, and attempt to keep a rollover record of previous logs.
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data remove storage isomorphic:config logging
execute unless data storage isomorphic:config logging.level run data modify storage isomorphic:config logging.level set value 1
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.level set value 1

execute unless data storage isomorphic:config logging.save run data modify storage isomorphic:config logging.save set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.save set value true

execute unless data storage isomorphic:config logging.max_size_excl run data modify storage isomorphic:config logging.max_size_excl set value 10
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.max_size_excl set value 10

# Now that logging is set correctly, we can announce we are reinstantiating the config.
data modify storage isomorphic:temp local.log_msg.datapack set value "isomorphic"
data modify storage isomorphic:temp local.log_msg.message set value {text:"Instantiating the config to ensure nothing is unset."}
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:temp local.log_msg.message set value {text:"Forcefully resetting the config."}
function isomorphic:api/log/trace with storage isomorphic:temp local.log_msg

# Defaults diagnostics to dump for all aborts.
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data remove storage isomorphic:config diagnostics
execute unless data storage isomorphic:config diagnostics.dump_on_abort run data modify storage isomorphic:config diagnostics.dump_on_abort set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config diagnostics.dump_on_abort set value true

execute unless data storage isomorphic:config diagnostics.record_calls run data modify storage isomorphic:config diagnostics.record_calls set value false
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config diagnostics.record_calls set value false

execute unless data storage isomorphic:config diagnostics.clear_history_on_reload run data modify storage isomorphic:config diagnostics.clear_history_on_reload set value false
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config diagnostics.clear_history_on_reload set value false

# Defaults to enable periodic functions to always be rescheduled, and to have a period of 1 second.
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data remove storage isomorphic:config periodic
execute unless data storage isomorphic:config periodic.agnostic_reschedule run data modify storage isomorphic:config periodic.agnostic_reschedule set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config periodic.agnostic_reschedule set value true

execute unless data storage isomorphic:config periodic.ticks run data modify storage isomorphic:config periodic.ticks set value 40
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config periodic.ticks set value 40


return 0