### Description:
# This will attempt to call a list of functions, recursively.
### Usage:
# function isomorphic:api/call_all {functions:[{namespace:<string>,function:<string>}}]} 
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/call_all",arguments:{functions:$(functions)}}