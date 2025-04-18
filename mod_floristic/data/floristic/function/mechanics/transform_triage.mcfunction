scoreboard players add @s floristic_race 0

execute if score @s floristic_race matches 0 run return run function floristic:mechanics/transform_random

# Returns to human if we have been transformed before.
scoreboard players set @s floristic_race 0
function floristic:mechanics/transformations/transform_human
