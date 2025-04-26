# Exit early if we are already all balanced.
execute as @s unless predicate prospective:any_invalid run advancement revoke @s only prospective:events/pickup_balancable

# Check every interactable slot.
execute as @s unless predicate prospective:valids/has_valid_boots run function prospective:mechanics/slot/balance_boots with entity @s equipment.feet
execute as @s unless predicate prospective:valids/has_valid_leggings run function prospective:mechanics/slot/balance_leggings with entity @s equipment.legs
execute as @s unless predicate prospective:valids/has_valid_chestplate run function prospective:mechanics/slot/balance_chestplate with entity @s equipment.chest
execute as @s unless predicate prospective:valids/has_valid_helmet run function prospective:mechanics/slot/balance_helmet with entity @s equipment.head
execute as @s unless predicate prospective:valids/has_valid_mainhand run function prospective:mechanics/slot/balance_mainhand with entity @s SelectedItem
execute as @s unless predicate prospective:valids/has_valid_offhand run function prospective:mechanics/slot/balance_offhand with entity @s equipment.offhand
execute as @s unless predicate prospective:valids/has_valid_slot0 run function prospective:mechanics/slot/balance_slot0 with entity @s Inventory[{Slot:0b}]
execute as @s unless predicate prospective:valids/has_valid_slot1 run function prospective:mechanics/slot/balance_slot1 with entity @s Inventory[{Slot:1b}]
execute as @s unless predicate prospective:valids/has_valid_slot2 run function prospective:mechanics/slot/balance_slot2 with entity @s Inventory[{Slot:2b}]
execute as @s unless predicate prospective:valids/has_valid_slot3 run function prospective:mechanics/slot/balance_slot3 with entity @s Inventory[{Slot:3b}]
execute as @s unless predicate prospective:valids/has_valid_slot4 run function prospective:mechanics/slot/balance_slot4 with entity @s Inventory[{Slot:4b}]
execute as @s unless predicate prospective:valids/has_valid_slot5 run function prospective:mechanics/slot/balance_slot5 with entity @s Inventory[{Slot:5b}]
execute as @s unless predicate prospective:valids/has_valid_slot6 run function prospective:mechanics/slot/balance_slot6 with entity @s Inventory[{Slot:6b}]
execute as @s unless predicate prospective:valids/has_valid_slot7 run function prospective:mechanics/slot/balance_slot7 with entity @s Inventory[{Slot:7b}]
execute as @s unless predicate prospective:valids/has_valid_slot8 run function prospective:mechanics/slot/balance_slot8 with entity @s Inventory[{Slot:8b}]

execute as @s run advancement revoke @s only prospective:events/pickup_balancable