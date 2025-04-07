### Description:
# This will load the dependency before the datapack.
### Usage:
# run isomorphic:internal/load_dependency {datapack:<string>,dependency:<string>}
###

$tellraw @a[gamemode=creative] "Attempting to load the dependency $(dependency) before $(datapack)"
scoreboard players set load_result isomorphic_scores 0

# We could provide a force option in the config, where we will disable the dependency before enabling in case it is already enabled

$execute store success score load_result isomorphic_scores run datapack enable "$(dependency)" before "$(datapack)"

