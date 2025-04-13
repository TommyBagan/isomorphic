
### Description:
# This will copy all isomorphic information to the .
### Usage:
# function isomorphic:api/  {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:<bool>}}
###

# Clears any previous dump.
data remove storage isomorphic:dump dump

# Records the initial timestamp.
execute store result storage isomorphic:dump dump.dumptime int 1 run time query gametime

# Copies all dump targets.
data modify storage isomorphic:dump dump.config.logging set from storage isomorphic:config logging
data modify storage isomorphic:dump dump.global.pm set from storage isomorphic:global pm
data modify storage isomorphic:dump dump.global.flags set from storage isomorphic:global flags
data modify storage isomorphic:dump dump.temp.local set from storage isomorphic:temp local
data modify storage isomorphic:dump dump.temp.history set from storage isomorphic:temp history
