### Description:
# This will attempt to call a list of functions, recursively.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/call_all",arguments:{functions:[{namespace:<string>,function:<string>}}]}} 
###

# Return if the list is empty, as there are no more functions to call.
execute store result storage isomorphic:temp local.func_count int 1 run data get storage isomorphic:temp local.arguments.functions
execute if data storage isomorphic:temp {local:{func_count:0}} run return 0

# Calls first in the list, and then removes it.
data modify storage isomorphic:temp local.arguments.functions[0].arguments set value {}
function isomorphic:api/call with storage isomorphic:temp local.arguments.functions[0]
data remove storage isomorphic:temp local.arguments.functions[0]

# Attempts to call the next.
return run function isomorphic:internal/wrapped/call_all