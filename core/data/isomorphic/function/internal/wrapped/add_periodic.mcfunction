### Description:
# This will add a function that will be called periodically via an isomorphic callback, according to the isomorphic config.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/add_periodic",arguments:{datapack:<string>,namespace:<string>,function:<string>}}
###

# Output a log.
data modify storage isomorphic:temp local.log_msg.datapack set from storage isomorphic:temp local.arguments.datapack
data modify storage isomorphic:temp local.log_msg.message set value [{text:"Adding a periodic function "},{storage:"isomorphic:temp",nbt:"local.caller.arguments.namespace"},{text:":"},{storage:"isomorphic:temp",nbt:"local.caller.arguments.function"},{text:"."}]
function isomorphic:api/log/trace with storage isomorphic:temp local.log_msg

# Add to the list.
# NOTE: Could check if it's been added already?
data modify storage isomorphic:temp local.element.namespace set from storage isomorphic:temp local.arguments.namespace
data modify storage isomorphic:temp local.element.function set from storage isomorphic:temp local.arguments.function
data modify storage isomorphic:global periodic.functions append from storage isomorphic:temp local.element

return 0