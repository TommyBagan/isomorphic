### Description:
# This will reset/instantiate the config.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:<bool>}}
###

# Defaults logging to emit for fatal errors & alerts, and attempt to keep a rollover record of previous logs.
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data remove storage isomorphic:config logging
execute unless data storage isomorphic:config {logging:{level:{}}} run data modify storage isomorphic:config logging.level set value 0
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.level set value 1

execute unless data storage isomorphic:config {logging:{save:{}}} run data modify storage isomorphic:config logging.save set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.save set value true

execute unless data storage isomorphic:config {logging:{max_size:{}}} run data modify storage isomorphic:config logging.max_size_excl set value 51
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config logging.max_size_excl set value 51

# Defaults diagnostics to dump for all aborts.
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data remove storage isomorphic:config diagnostics
execute unless data storage isomorphic:config {diagnostics:{dump_on_abort:{}}} run data modify storage isomorphic:config diagnostics.dump_on_abort set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config diagnostics.dump_on_abort set value true

execute unless data storage isomorphic:config {diagnostics:{record_calls:{}}} run data modify storage isomorphic:config diagnostics.record_calls set value true
execute if data storage isomorphic:temp {local:{arguments:{force:true}}} run data modify storage isomorphic:config diagnostics.record_calls set value true
