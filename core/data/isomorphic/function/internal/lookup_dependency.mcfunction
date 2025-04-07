### Description:
# This will lookup the dependency associated with a datapack and iterator.
### Usage:
# run isomorphic:internal/lookup_dependency {datapack:<string>,iterator:<int>}
###

$tellraw @a[gamemode=creative] "Attempting to lookup the dependency $(iterator) for $(datapack)"

# Puts found dependency and its path into storage
$data modify storage isomorphic:temp working.dependency set from storage isomorphic:global pm."$(datapack)".dependencies[$(iterator)]

# Checks if the pack is registered
return run function isomorphic:internal/verify_registered with storage isomorphic:temp working
