### Description:
# This will check if the dependency is registered. 
### Usage:
# run isomorphic:internal/verify_registered {dependency:<string>}
###

$tellraw @a[gamemode=creative] "Verifying this is registered: $(dependency)"

# Returns early if the datapack doesn't exist
$execute unless data storage isomorphic:global {pm:{"$(dependency)":{}}} run return 1

# Returns if the datapack is registered
$execute if data storage isomorphic:global {pm:{"$(dependency)":{registered:true}}} run return 0

# Returns for any other failure cases
return 2