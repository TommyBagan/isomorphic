execute run execute store result score @s floristic_race run random value 1..2

execute if score @s floristic_race matches 1 run execute as @s run function floristic:mechanics/transformations/transform_giant
execute if score @s floristic_race matches 2 run execute as @s run function floristic:mechanics/transformations/transform_dwarf