
### Description:
# This will set the config to be most efficient.
### Usage:
# function isomorphic:config/efficient
###

# Makes sure all values in the config are set.
function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:false}}

# Makes the logging level only for fatal and above.
data modify storage isomorphic:config logging.level set value 4

# Turns off log rollover.
data modify storage isomorphic:config logging.save set value false
data modify storage isomorphic:config logging.max_size_excl set value 0

# We disable dump on abort, its assumed with this config you want things to be smooth.
data modify storage isomorphic:config diagnostics.dump_on_abort set value true

# Certainly disable the recording feature, it can produce a large history backlog.
data modify storage isomorphic:config diagnostics.record_calls set value false

# The history can be bloated, so we should clear it.
data modify storage isomorphic:config diagnostics.clear_history_on_reload set value true

# The dump is huge and may be loaded into cache, so we should clear it.
data modify storage isomorphic:config diagnostics.clear_dump_on_reload set value true

# Agnostic rescheduling can cause unnecessary operations, so is disabled.
data modify storage isomorphic:config periodic.agnostic_reschedule set value false

# The period functions are run should be longer than usual, as we likely don't need the commands run frequently.
data modify storage isomorphic:config periodic.ticks set value 40