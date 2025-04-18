### Description:
# This will attempt to reschedule the periodic function when it has failed due to a preexisting call stack.
### Usage:
# function isomorphic:internal/subroutine/retry_reschedule
###

# NOTE: Right now, we face an infinite loop situation if the call stack is corrupted.
# It's possible after some time we may want to recover or abort. This could be configurable?
# Unsure how to decide this right now...

# Attempts to retry via rescheduling the main routine.
return run function isomorphic:internal/subroutine/reschedule_periodic_calls