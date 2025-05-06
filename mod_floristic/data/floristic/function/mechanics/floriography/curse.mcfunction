playsound minecraft:entity.allay.death ambient @s ~ ~ ~ 3 0.2
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.curse",italic:true}}

effect give @s darkness 20 3 true
effect give @s wither 20 2 true
effect give @s hunger infinite 1 true

