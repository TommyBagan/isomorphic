### Description:
# This will verify all dependencies associated with a datapack, and recursively call until complete.
### Usage:
# run isomorphic:internal/verify_dependency_list {datapack:<string>}
###

tellraw @a[gamemode=creative] [{"text": "Verifying dependency indexed at: "},{"score":{name:"dep_iter",objective:"isomorphic_scores"}}]
execute if score dep_iter isomorphic_scores >= dep_count isomorphic_scores run return 0

# Puts the iterator back to temp storage for a lookup
execute store result storage isomorphic:temp working.iterator int 1 run scoreboard players get dep_iter isomorphic_scores
scoreboard players set list_result isomorphic_scores 0
execute store result score list_result isomorphic_scores run function isomorphic:internal/lookup_dependency with storage isomorphic:temp working

tellraw @a[gamemode=creative] [{"text": "Lookup returned: "},{"score":{name:"list_result",objective:"isomorphic_scores"}}]

# If it fails due to an non-zero retcode, we attempt to load_dependency
execute if score list_result isomorphic_scores matches 1.. run function isomorphic:internal/load_dependency with storage isomorphic:temp working

# Load dependency sets load_result to a 1 on success
execute if score load_result isomorphic_scores matches 0 run return 1

# Increments and recursively calls
scoreboard players add dep_iter isomorphic_scores 1
$return run function isomorphic:internal/verify_dependency_list {datapack:"$(datapack)"}
