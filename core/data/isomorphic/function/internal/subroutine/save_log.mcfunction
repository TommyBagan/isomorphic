### Description:
# This will save a log to storage.
### Usage:
# function isomorphic:internal/subroutine/save_log 
### Assumes:
# local.arguments exists, which should be the arguments for a internal/wrapped/log call.
###

# Performs log rollover, by removing the first value if the max size has been reached.
execute if predicate {condition:"value_check",range:{min:{type:"storage",path:"logging.max_size_excl",storage:"isomorphic:config"}},value:{type:"storage",path:"history.log",storage:"isomorphic:temp"}} run data remove storage isomorphic:temp history.log[0]

# Appends the call to the history.
data modify storage isomorphic:temp history.log append from storage isomorphic:temp local.arguments
