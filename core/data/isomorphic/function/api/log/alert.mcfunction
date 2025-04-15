### Description:
# This will emit an alert level log for an isomorphic datapack.
### Usage:
# function isomorphic:api/log/alert {datapack:<string>,message:<text_component>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:2,datapack:$(datapack),message:$(message)}}