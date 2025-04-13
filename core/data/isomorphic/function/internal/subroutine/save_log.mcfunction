### Description:
# This will save a log to storage.
### Usage:
# function isomorphic:internal/subroutine/save_log 
### Assumes:
# local.arguments exists, which should be the arguments for a internal/wrapped/log call.
###

# Performs log rollover, by removing the first value if the max size has been reached.
execute store result storage isomorphic:temp history.log_size int 1 run data get storage isomorphic:temp history.log
execute if predicate isomorphic:logging/is_log_history_too_large run data remove storage isomorphic:temp history.log[0]

# Appends the call to the history.
data modify storage isomorphic:temp history.log append from storage isomorphic:temp local.arguments
