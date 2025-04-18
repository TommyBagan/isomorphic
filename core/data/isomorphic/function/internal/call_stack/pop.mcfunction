### Description:
# This will pop a local stack frame in isomorphic:temp.
### Usage:
# function isomorphic:internal/call_stack/pop
###

# Records the attempt at a pop.
execute if data storage isomorphic:config {diagnostics:{record_calls:true}} run data modify storage isomorphic:temp history.calls prepend value {popped:{}}
execute if data storage isomorphic:config {diagnostics:{record_calls:true}} run data modify storage isomorphic:temp history.calls[0].popped.function set from storage isomorphic:temp local.function
execute if data storage isomorphic:config {diagnostics:{record_calls:true}} run data modify storage isomorphic:temp history.calls[0].popped.namespace set from storage isomorphic:temp local.namespace

# Ensure's we aren't at the top of the stack
execute store success storage isomorphic:temp local.func_check int 1 run data get storage isomorphic:temp local.function

# If we pop at the top level we will get this error. It's important to hard push and log the issue, as the stack is corrupted anyway so we just need one last log.
execute unless data storage isomorphic:temp {local:{func_check:1}} run data modify storage isomorphic:global flags.call_stack_corrupted set value true
execute unless data storage isomorphic:temp {local:{func_check:1}} run function isomorphic:api/log/abort {datapack:"isomorphic",message:{text:"The call stack is corrupted! Please report this to the developer(s) of the datapack."}}
execute unless data storage isomorphic:temp {local:{func_check:1}} run return 255

# Pops from the call stack
data modify storage isomorphic:temp local set from storage isomorphic:temp local.caller

# Returns the return code on the top of the call stack
return run data get storage isomorphic:temp local.return_code