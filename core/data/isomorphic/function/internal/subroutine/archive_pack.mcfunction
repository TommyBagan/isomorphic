### Description:
# This will archive an isomorphic datapack, so other packs can search for it as a dependency..
### Usage:
# function isomorphic:internal/subroutine/archive_pack" {name:<string>,path:<string>,dependencies:[<string>,...]}
###

# Resets the dependency list, as it would have been altered.
data modify storage isomorphic:global pm.this.dependencies set from storage isomorphic:temp local.arguments.dependencies

# Removes this field to avoid duplication.
data remove storage isomorphic:global pm.this.path

# Core specific behaviour, whereby we reset the package management in global.
execute if data storage isomorphic:temp {local:{name:"isomorphic"}} run data modify storage isomorphic:temp local.archive set from storage isomorphic:global pm.this
execute if data storage isomorphic:temp {local:{name:"isomorphic"}} run data remove storage isomorphic:global pm
execute if data storage isomorphic:temp {local:{name:"isomorphic"}} run data modify storage isomorphic:global pm.this set from storage isomorphic:temp local.archive

# Copies the package record so other datapacks can search for it
$data modify storage isomorphic:global pm."$(path)" set from storage isomorphic:global pm.this

# Clears the this as it won't be needed.
data remove storage isomorphic:global pm.this