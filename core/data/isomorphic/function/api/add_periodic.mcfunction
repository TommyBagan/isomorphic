### Description:
# This will add a function that will be called periodically, according to the isomorphic config.
### Usage:
# function isomorphic:api/add_periodic {datapack:<string>,namespace:<string>,function:<string>}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/add_periodic",arguments:{datapack:$(datapack),namespace:$(namespace),function:$(function)}}