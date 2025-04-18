
### Description:
# This will copy all isomorphic information to isomorphic:dump/dump.
### Usage:
# function isomorphic:api/dump
###

# Clears any previous dump.
data remove storage isomorphic:dump dump

# Records the initial timestamp.
execute store result storage isomorphic:dump dump.dumptime int 1 run time query gametime

# Copies all dump targets.
data modify storage isomorphic:dump dump.config.logging set from storage isomorphic:config logging
data modify storage isomorphic:dump dump.config.diagnostics set from storage isomorphic:config diagnostics
data modify storage isomorphic:dump dump.config.periodic set from storage isomorphic:config periodic

data modify storage isomorphic:dump dump.global.pm set from storage isomorphic:global pm
data modify storage isomorphic:dump dump.global.periodic set from storage isomorphic:global periodic
data modify storage isomorphic:dump dump.global.flags set from storage isomorphic:global flags

data modify storage isomorphic:dump dump.temp.local set from storage isomorphic:temp local
data modify storage isomorphic:dump dump.temp.history set from storage isomorphic:temp history
