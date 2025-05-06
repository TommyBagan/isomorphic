playsound minecraft:entity.zombie_villager.cure ambient @s ~ ~ ~ 0.1 1.1
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.heal",italic:true}}

execute if predicate floristic:favour/is_rated_a run effect give @e[distance=..3,type=player,gamemode=survival] instant_health 1 4
execute if predicate floristic:favour/is_rated_a run effect give @e[distance=..3,type=player,gamemode=survival] absorption 10 2
execute if predicate floristic:favour/is_rated_a run return 0


execute if predicate floristic:favour/is_rated_b run effect give @e[distance=..3,type=player,gamemode=survival] instant_health 1 3
execute if predicate floristic:favour/is_rated_b run effect give @e[distance=..3,type=player,gamemode=survival] absorption 10 1
execute if predicate floristic:favour/is_rated_b run return 0

execute if predicate floristic:favour/is_rated_c run effect give @e[distance=..3,type=player,gamemode=survival] instant_health 1 2
execute if predicate floristic:favour/is_rated_c run return 0

effect give @e[distance=..3,type=player,gamemode=survival] instant_health 1 1