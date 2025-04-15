### Description:
# This will emit an fatal level log for an isomorphic datapack.
### Usage:
# function isomorphic:api/log/fatal {datapack:<string>,message:<text_component>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:3,datapack:$(datapack),message:$(message)}}