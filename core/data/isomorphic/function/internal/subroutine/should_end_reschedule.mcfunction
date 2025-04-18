### Description:
# This will return 1 if there are no functions left, for a strict reschedule.
### Usage:
# function isomorphic:internal/subroutine/should_end_reschedule
###

# If the function count is non-zero, we exit early.
execute store result storage isomorphic:temp local.func_count int 1 run data get storage isomorphic:global periodic.functions
execute unless data storage isomorphic:temp {local:{func_count:0}} run return 0

# Output an alert message as a change in behaviour has ocurred.
function isomorphic:api/log/alert with storage isomorphic:temp {datapack:"isomorphic",message:{text:"No longer running periodic functions, as the list is empty!"}}

# Equivalent to true
return 1