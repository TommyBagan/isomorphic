playsound minecraft:block.bell.use ambient @s ~ ~ ~ 3 0.5
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.smite",italic:true}}

execute at @e[distance=..16,type=#undead] run summon lightning_bolt ~ ~ ~
