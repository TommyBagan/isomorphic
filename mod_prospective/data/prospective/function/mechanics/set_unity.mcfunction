# This temp value is used to determine if we shall remove unity or not.
scoreboard players add @s prospective_unity 0
scoreboard players set @s prospective_unity_temp 0

# Assume the armor has been removed.
execute as @s run function prospective:mechanics/remove_unity

# Test for all the armor types.
execute as @s if predicate prospective:has_full_iron run function prospective:mechanics/unity_type/iron_unity
execute as @s if predicate prospective:has_full_golden run function prospective:mechanics/unity_type/golden_unity
execute as @s if predicate prospective:has_full_diamond run function prospective:mechanics/unity_type/diamond_unity
execute as @s if predicate prospective:has_full_netherite run function prospective:mechanics/unity_type/netherite_unity
execute as @s if predicate prospective:has_full_leather run function prospective:mechanics/unity_type/leather_unity
execute as @s if predicate prospective:has_full_chainmail run function prospective:mechanics/unity_type/chainmail_unity

# Output the action bar messages only when needed to.
execute as @s if score @s prospective_unity matches 1.. run execute if score @s prospective_unity_temp matches 0 run title @s actionbar {"translate":"actionbar.prospective.unity.lose"}
execute as @s if score @s prospective_unity matches 0 run execute if score @s prospective_unity_temp matches 1 run title @s actionbar {"translate":"actionbar.prospective.unity.gain"}

# Ensure if there is no unity, we store a 0.
scoreboard players operation @s prospective_unity += @s prospective_unity_temp
execute if score @s prospective_unity_temp matches 0 run scoreboard players set @s prospective_unity 0

execute as @s run advancement revoke @s only prospective:events/unity