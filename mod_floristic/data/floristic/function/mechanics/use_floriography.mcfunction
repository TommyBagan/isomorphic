execute as @s run function floristic:mechanics/floriography/read

particle tinted_leaves{color:[1,0.4,0.6,0]} ~ ~1 ~ 1 1 1 1 10 force @a

execute if predicate floristic:favour/is_rated_a run title @s actionbar {"translate":"item.floristic.floriography.favour.a"}
execute if predicate floristic:favour/is_rated_b run title @s actionbar {"translate":"item.floristic.floriography.favour.b"}
execute if predicate floristic:favour/is_rated_c run title @s actionbar {"translate":"item.floristic.floriography.favour.c"}
execute if predicate floristic:favour/is_rated_d run title @s actionbar {"translate":"item.floristic.floriography.favour.d"}
execute if predicate floristic:favour/is_rated_e run title @s actionbar {"translate":"item.floristic.floriography.favour.e"}
execute if predicate floristic:favour/is_rated_f run title @s actionbar {"translate":"item.floristic.floriography.favour.f"}
execute if predicate floristic:favour/is_rated_g run title @s actionbar {"translate":"item.floristic.floriography.favour.g"}
execute if predicate floristic:favour/is_rated_h run title @s actionbar {"translate":"item.floristic.floriography.favour.h"}
execute if predicate floristic:favour/is_rated_i run title @s actionbar {"translate":"item.floristic.floriography.favour.i"}

advancement revoke @s only floristic:events/event_floriography
