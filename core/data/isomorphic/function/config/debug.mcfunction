### Description:
# This will enable rules in the config for debugging.
### Usage:
# function isomorphic:config/debug
###

# Makes sure all values in the config are set.
function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:false}}

# Most verbose logging level.
data modify storage isomorphic:config logging.level set value 0

# Turns on log rollover with a large log history.
data modify storage isomorphic:config logging.save set value true
data modify storage isomorphic:config logging.max_size_excl set value 101

# Output an alert.
data modify storage isomorphic:temp local.log_msg.datapack set value "isomorphic"
data modify storage isomorphic:temp local.log_msg.message set value {text:"Enabling debug mode, this may cause some lag."}
function isomorphic:api/log/alert with storage isomorphic:temp local.log_msg

# Enable dumping.
data modify storage isomorphic:config diagnostics.dump_on_abort set value true

# We record a history of all calls - this will cause the most lag.
data modify storage isomorphic:config diagnostics.record_calls set value true

# The history may have useful information, so we shouldn't clear it.
data modify storage isomorphic:config diagnostics.clear_history_on_reload set value false

# The dump needs to persist for debugging.
data modify storage isomorphic:config diagnostics.clear_dump_on_reload set value false

# Agnostic rescheduling would be helpful, as debug environments may lag.
data modify storage isomorphic:config periodic.agnostic_reschedule set value true

# The period functions should run frequently as we debug the issue.
data modify storage isomorphic:config periodic.ticks set value 20
