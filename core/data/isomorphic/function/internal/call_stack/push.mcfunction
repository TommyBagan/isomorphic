### Description:
# This will generate a local stack in isomorphic:temp.
### Usage:
# function isomorphic:push {namespace:<name>,function:<name>,arguments:<object>}
###

# Records the attempt at a push.
$execute if data storage isomorphic:config {diagnostics:{record_calls:true}} run data modify storage isomorphic:temp history.calls prepend value {pushed:{namespace:"$(namespace)",function:"$(function)"}}

# If we are at the top of the stack, we instantiate it.
execute store success storage isomorphic:temp local.func_check int 1 run data get storage isomorphic:temp local.function
execute if data storage isomorphic:temp {local:{func_check:0}} run data modify storage isomorphic:temp local.root set value true
data remove storage isomorphic:temp local.func_check

# Creates the call stack, via copying the existing stack temporarily.
data modify storage isomorphic:temp stack set from storage isomorphic:temp local
data remove storage isomorphic:temp local
data modify storage isomorphic:temp local.caller set from storage isomorphic:temp stack
data remove storage isomorphic:temp stack

# Populates all fields of the current call stack
$data modify storage isomorphic:temp local.function set value "$(function)"
$data modify storage isomorphic:temp local.namespace set value "$(namespace)"
$data modify storage isomorphic:temp local.arguments set value $(arguments)
execute store result storage isomorphic:temp local.timestamp int 1 run time query gametime


return 0