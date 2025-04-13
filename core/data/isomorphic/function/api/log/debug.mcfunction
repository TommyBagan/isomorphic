### Description:
# This will emit an debug level log for an isomorphic datapack.
### Usage:
# run isomorphic:api/log/debug {datapack:<string>,message:<text_component>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:0,datapack:$(datapack),message:$(message)}}