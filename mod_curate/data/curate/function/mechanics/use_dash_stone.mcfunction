# We reset the player's hand, as the item will be consumed in the next tick.
execute if data entity @s {SelectedItem:{components:{"minecraft:custom_data":{actual_id:"dash_stone"}}}} run function curate:mechanics/replace_equipment {hand:mainhand}
execute if data entity @s {equipment:{offhand:{components:{"minecraft:custom_data":{actual_id:"dash_stone"}}}}} run function curate:mechanics/replace_equipment {hand:offhand}

# We record the dash distance as an integer.
scoreboard objectives add curate_dash_dash_dist dummy
scoreboard players set @s curate_dash_dash_dist 0

# This will perform a ray cast, to find out the longest line of non-solid blocks.
execute store result score @s curate_dash_dash_dist run execute as @s positioned ~ ~0.5 ~ run function curate:mechanics/dash_ray

# We emit the wind sound if we are about to be teleported.
execute unless score @s curate_dash_dash_dist matches 0 run playsound minecraft:entity.breeze.shoot player @s ~ ~ ~ 0.1 1.2

# We teleport just before the solid block we found.
execute if score @s curate_dash_dash_dist matches 1 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^0.3
execute if score @s curate_dash_dash_dist matches 2 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^0.8
execute if score @s curate_dash_dash_dist matches 3 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^1.3
execute if score @s curate_dash_dash_dist matches 4 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^1.8
execute if score @s curate_dash_dash_dist matches 5 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^2.3
execute if score @s curate_dash_dash_dist matches 6 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^2.8
execute if score @s curate_dash_dash_dist matches 7 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^3.3
execute if score @s curate_dash_dash_dist matches 8 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^3.8
execute if score @s curate_dash_dash_dist matches 9 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^4.3
execute if score @s curate_dash_dash_dist matches 10 run execute as @s positioned ~ ~0.5 ~ run tp @s ^ ^ ^4.8

# Reset the event.
execute at @s run advancement revoke @s only curate:events/event_dash_stone