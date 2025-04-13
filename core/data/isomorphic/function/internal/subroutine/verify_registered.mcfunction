### Description:
# This will check if the dependency is registered. 
### Usage:
# run isomorphic:internal/verify_registered {dependency:<string>}
###

# Logging for debugging purposes.
$data modify storage isomorphic:temp local.log_msg.message set value [{text:"Verifying if $(dependency) is registered."}]
function isomorphic:api/log/debug with storage isomorphic:temp local.log_msg

# Returns early if the datapack doesn't exist
$execute unless data storage isomorphic:global {pm:{"$(dependency)":{}}} run return 1

# Returns if the datapack is registered
$execute if data storage isomorphic:global {pm:{"$(dependency)":{registered:true}}} run return 0

# Returns for any other failure cases
return 2