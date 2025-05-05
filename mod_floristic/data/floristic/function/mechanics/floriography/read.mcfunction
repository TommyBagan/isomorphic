execute if predicate floristic:can_transform run function floristic:mechanics/floriography/transform
execute if predicate floristic:can_transform run return 0

# If nothing else gets ran, we default to just simple worship.
execute as @s run function isomorphic:helper/local_say {"message":{"translate":"item.floristic.floriography.worship"}}
