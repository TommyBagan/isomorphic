playsound minecraft:block.bell.resonate ambient @s ~ ~ ~ 1 2
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.praise",italic:true}}

scoreboard players add @s floristic_idris_favour 10
execute as @s run function floristic:mechanics/bound_favour