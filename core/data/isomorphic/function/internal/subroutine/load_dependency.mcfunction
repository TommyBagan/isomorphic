### Description:
# This will load the dependency before the datapack.
### Usage:
# run isomorphic:internal/load_dependency {datapack:<string>,dependency:<string>}
###

# Demonstrates what we are attempting to accomplish.
$data modify storage isomorphic:temp local.log_msg.message set value [{text:"Attempting to load the dependency $(dependency) before myself."}]
function isomorphic:api/log/debug with storage isomorphic:temp local.log_msg

# Attempts to load the dependency before the current datapack.
# NOTE: We could provide a force option in the config, where we will disable the dependency before enabling in case it is already enabled
$execute store success storage isomorphic:temp local.success_code int 1 run datapack enable "$(dependency)" before "$(datapack)"
