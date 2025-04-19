scoreboard players set @s prospective_unity 0

# Assume the armor has been removed.
function prospective:mechanics/remove_unity

# Test for all the armor types.
execute as @s if predicate prospective:has_full_iron run function prospective:mechanics/unity_type/iron_unity
execute as @s if predicate prospective:has_full_golden run function prospective:mechanics/unity_type/golden_unity
execute as @s if predicate prospective:has_full_diamond run function prospective:mechanics/unity_type/diamond_unity
execute as @s if predicate prospective:has_full_netherite run function prospective:mechanics/unity_type/netherite_unity

# Output a useful message.
execute as @s if score @s prospective_unity matches 1.. run title @s actionbar {"translate":"actionbar.prospective.unity"}

execute as @s run advancement revoke @s only prospective:events/unity