### Description:
# This will emit an trace level log for an isomorphic datapack.
### Usage:
# function isomorphic:api/log/trace {message:<text_component>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:1,datapack:$(datapack),message:$(message)}}