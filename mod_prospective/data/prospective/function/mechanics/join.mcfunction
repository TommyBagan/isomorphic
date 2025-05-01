execute as @s run function isomorphic:api/log/trace {datapack:"prospective",message:[{text:"Welcomed "},{selector:"@s"},{text:" with a harsh reality."}]}
execute as @s run attribute @s max_health base set 8
execute as @s run attribute @s attack_speed base set 1
execute as @s run attribute @s attack_damage base set 0.5
execute as @s run attribute @s entity_interaction_range base set 1
execute as @s run attribute @s attack_knockback base set 0
execute as @s run tag @s add joined
