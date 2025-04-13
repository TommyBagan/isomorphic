### Description:
# This will emit an abort level log for an isomorphic datapack.
### Usage:
# run isomorphic:api/log/abort {datapack:<string>,message:<text_component>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/log",arguments:{level:4,datapack:$(datapack),message:$(message)}}