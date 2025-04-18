### Description:
# This will attempt to reschedule the periodic function call according to the config.
### Usage:
# function isomorphic:internal/subroutine/reschedule_periodic_calls
###

# Runs a small optimisation to avoid calling a macro.
execute if data storage isomorphic:config {periodic:{ticks:40}} run return run schedule function isomorphic:internal/subroutine/main_periodic 40 replace

# Reschedules again with a custom tick period.
function isomorphic:internal/subroutine/custom_reschedule with storage isomorphic:config periodic
