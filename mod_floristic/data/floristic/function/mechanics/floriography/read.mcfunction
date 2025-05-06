execute if predicate floristic:favour/is_rated_i run return run function floristic:mechanics/floriography/curse

execute if entity @e[distance=..3,type=player,gamemode=survival] run execute as @s if predicate floristic:can_heal run return run function floristic:mechanics/floriography/heal

execute if entity @e[distance=..16,type=#undead] run execute as @s if predicate floristic:can_smite run return run function floristic:mechanics/floriography/smite

execute if predicate floristic:can_transform run return run function floristic:mechanics/floriography/transform

execute if predicate floristic:can_praise run return run function floristic:mechanics/floriography/praise

# If nothing else gets ran, we default to just simple worship.
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.worship",italic:true}}
scoreboard players add @s floristic_idris_favour 2
execute as @s run function floristic:mechanics/bound_favour
playsound minecraft:block.amethyst_block.chime
