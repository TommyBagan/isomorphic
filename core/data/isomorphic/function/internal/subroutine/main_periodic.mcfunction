### Description:
# This is the main rountine for running functions.
### Usage:
# function isomorphic:internal/subroutine/main_periodic
###

# We schedule again if the call stack isn't empty, as it indicates something new is happening.
execute unless predicate isomorphic:call_stack/is_stack_empty run return run function isomorphic:internal/subroutine/retry_reschedule

# Returns early if we aren't rescheduling due to strict rescheduling requirements.
execute if data storage isomorphic:config {periodic:{agnostic_reschedule:false}} run execute if function isomorphic:internal/subroutine/should_end_reschedule run return 1

# Calls all within the periodic functions cache list.
function isomorphic:api/call_all with storage isomorphic:global periodic

# Reschedules the main_periodic
function isomorphic:internal/subroutine/reschedule_periodic_calls