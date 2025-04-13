### Description:
# This will remove an isomorphic datapack archive.
### Usage:
# function isomorphic:internal/subroutine/remove_archive" {path:<string>}
###

# Removes the package record.
$data remove storage isomorphic:global pm."$(path)"
