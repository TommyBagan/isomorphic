execute run execute store result score @s floristic_race run random roll 1..2

execute if score @s floristic_race matches 1 run function floristic:mechanics/transformations/transform_giant
execute if score @s floristic_race matches 2 run function floristic:mechanics/transformations/transform_dwarf