scoreboard players add @s floristic_race 0

playsound entity.creaking.spawn ambient @s ~ ~ ~ 1 2
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.transform",italic:true}}

execute if score @s floristic_race matches 0 run return run execute as @s run function floristic:mechanics/transformations/transform_random

# Returns to human if we have been transformed before.
scoreboard players set @s floristic_race 0
function floristic:mechanics/transformations/transform_human
