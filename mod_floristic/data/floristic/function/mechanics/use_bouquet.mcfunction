execute as @e[distance=..5,type=#floristic:lovers,sort=nearest,limit=1] at @e[distance=..5,type=#floristic:lovers,sort=nearest,limit=1] run loot spawn ^ ^1 ^ loot floristic:gameplay/valentines_gift
execute at @e[distance=..5,type=#floristic:lovers,sort=nearest,limit=1] run particle minecraft:heart ~ ~2 ~ 0 0 0 0.1 1
execute at @s run advancement revoke @s only floristic:events/event_tulip_bouquet
