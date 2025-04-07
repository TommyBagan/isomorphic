### Description:
# This will register an isomorphic datapack, and verify its dependencies are present.
### Usage:
# run isomorphic:api/register {name:<string>,path:<string>,dependencies:[<string>,...]}
###

# Start the registration
$data modify storage isomorphic:global pm."$(path)".registered set value false
$tellraw @a [{"translate": "Attempting to register ","color": "gray"},{"translate": "$(name)","color": "yellow"}]


# In global storage, store the inputted values
$data modify storage isomorphic:global pm."$(path)".dependencies set value $(dependencies)

# In temp storage, store the inputted values
$data modify storage isomorphic:temp working.datapack set value "$(path)"

# Instantiates a table
scoreboard objectives add isomorphic_scores dummy

scoreboard players set dep_iter isomorphic_scores 0

# Store length of $(dependencies) in the scoreboard as dep_count
$execute store result score dep_count isomorphic_scores run data get storage isomorphic:global pm."$(path)".dependencies

# Verifies dependency list
$execute store result score dep_result isomorphic_scores run function isomorphic:internal/verify_dependency_list {datapack:"$(path)"}

# Clears the working area
# data remove storage isomorphic:temp working

# Emits the message once loaded
$execute if score dep_result isomorphic_scores matches 0 run data modify storage isomorphic:global pm."$(path)".registered set value true
$execute if score dep_result isomorphic_scores matches 0 run tellraw @a [{"translate": "Successfully registered ","color": "gray"},{"translate": "$(name)","color": "green"}]
$execute unless score dep_result isomorphic_scores matches 0 run tellraw @a [{"translate": "Failed to register ","color": "gray"},{"translate": "$(name)","color": "red"}]


