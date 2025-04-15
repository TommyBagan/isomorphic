# Runs 3 rays out from centre of player in the direction of where they are looking, 
# returning the amount of blocks the player can teleport forward with.
execute as @s unless block ^ ^ ^0.5 #curio:non-solids run return 0
execute as @s positioned ^ ^ ^0.5 unless block ~ ~1 ~ #curio:non-solids run return 0
execute as @s positioned ^ ^ ^0.5 run particle minecraft:white_smoke ~ ~ ~

execute as @s unless block ^ ^ ^1.0 #curio:non-solids run return 1
execute as @s positioned ^ ^ ^1.0 unless block ~ ~1 ~ #curio:non-solids run return 1
execute as @s positioned ^ ^ ^1.0 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^1.0 #curio:non-solids run return 1
# execute as @s unless block ^ ^-0.05 ^1.0 #curio:non-solids run return 1

execute as @s unless block ^ ^ ^1.5 #curio:non-solids run return 2
execute as @s positioned ^ ^ ^1.5 unless block ~ ~1 ~ #curio:non-solids run return 2
execute as @s positioned ^ ^ ^1.5 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^1.5 #curio:non-solids run return 2
# execute as @s unless block ^ ^-0.05 ^1.5 #curio:non-solids run return 2

execute as @s unless block ^ ^ ^2.0 #curio:non-solids run return 3
execute as @s positioned ^ ^ ^2.0 unless block ~ ~1 ~ #curio:non-solids run return 3
execute as @s positioned ^ ^ ^2.0 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^2.0 #curio:non-solids run return 3
#execute as @s unless block ^ ^-0.05 ^2.0 #curio:non-solids run return 3

execute as @s unless block ^ ^ ^2.5 #curio:non-solids run return 4
execute as @s positioned ^ ^ ^2.5 unless block ~ ~1 ~ #curio:non-solids run return 4
execute as @s positioned ^ ^ ^2.5 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^2.5 #curio:non-solids run return 4
#execute as @s unless block ^ ^-0.05 ^2.5 #curio:non-solids run return 4

execute as @s unless block ^ ^ ^3.0 #curio:non-solids run return 5
execute as @s positioned ^ ^ ^3.0 unless block ~ ~1 ~ #curio:non-solids run return 5
execute as @s positioned ^ ^ ^3.0 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^3.0 #curio:non-solids run return 5
#execute as @s unless block ^ ^-0.05 ^3.0 #curio:non-solids run return 5

execute as @s unless block ^ ^ ^3.5 #curio:non-solids run return 6
execute as @s positioned ^ ^ ^3.5 unless block ~ ~1 ~ #curio:non-solids run return 6
execute as @s positioned ^ ^ ^3.5 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^3.5 #curio:non-solids run return 6
#execute as @s unless block ^ ^-0.05 ^3.5 #curio:non-solids run return 6

execute as @s unless block ^ ^ ^4.0 #curio:non-solids run return 7
execute as @s positioned ^ ^ ^4.0 unless block ~ ~1 ~ #curio:non-solids run return 7
execute as @s positioned ^ ^ ^4.0 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^4.0 #curio:non-solids run return 7
#execute as @s unless block ^ ^-0.05 ^4.0 #curio:non-solids run return 7

execute as @s unless block ^ ^ ^4.5 #curio:non-solids run return 8
execute as @s positioned ^ ^ ^4.5 unless block ~ ~1 ~ #curio:non-solids run return 8
execute as @s positioned ^ ^ ^4.5 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^4.5 #curio:non-solids run return 8
#execute as @s unless block ^ ^-0.05 ^4.5 #curio:non-solids run return 8

execute as @s unless block ^ ^ ^5.0 #curio:non-solids run return 9
execute as @s positioned ^ ^ ^5.0 unless block ~ ~1 ~ #curio:non-solids run return 9
execute as @s positioned ^ ^ ^5.0 run particle minecraft:white_smoke ~ ~ ~
#execute as @s unless block ^ ^0.05 ^5.0 #curio:non-solids run return 9
#execute as @s unless block ^ ^-0.05 ^5.0 #curio:non-solids run return 9

return 10