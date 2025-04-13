### Description:
# This will attempt to run a function with a generated local stack in isomorphic:temp.
### Usage:
# function isomorphic:api/call {namespace:<name>,function:<name>,arguments:<object>}
###

# Pushes the call stack.
$function isomorphic:internal/call_stack/push {namespace:"$(namespace)",function:"$(function)",arguments:$(arguments)}

# Runs the function, which can read from local.arguments.
$execute store result storage isomorphic:temp local.caller.return_code int 1 run function $(namespace):$(function)

# We exit the call routines early if we detect stack corruption.
execute if data storage isomorphic:global {flags:{call_stack_corrupted:true}} run return 255

# Pops the call stack.
return run function isomorphic:internal/call_stack/pop