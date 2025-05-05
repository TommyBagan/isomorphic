execute as @s run function floristic:mechanics/floriography/read

particle tinted_leaves{color:[1,0.4,0.6,0]} ~ ~1 ~ 1 1 1 1 10 force @a

advancement revoke @s only floristic:events/event_floriography
