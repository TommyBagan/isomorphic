### Description:
# This will verify all dependencies associated with a datapack, and recursively call until complete.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/verify_dependency_list",arguments:{}}
###

# Logs out the dependency message.
data modify storage isomorphic:temp local.log_msg.datapack set from storage isomorphic:global pm.this.datapack
data modify storage isomorphic:temp local.log_msg.message set value [{text:"Got "},{storage:"isomorphic:global",nbt:"pm.this.dependencies"},{text:" dependencies left."}]
function isomorphic:api/log/debug with storage isomorphic:temp local.log_msg

# Returns early if we have exceeded the dependency count.
execute store result storage isomorphic:global pm.this.dependencies_size int 1 run data get storage isomorphic:global pm.this.dependencies
execute if predicate isomorphic:package_management/is_dependency_stack_empty run return 0

# Outputs a log message
data modify storage isomorphic:temp local.lookup.dependency set from storage isomorphic:global pm.this.dependencies[0]

# Verifies if the current dependency is registered against.
execute store result storage isomorphic:temp local.return_code int 1 run function isomorphic:internal/subroutine/verify_registered with storage isomorphic:temp local.lookup

# If it fails due to an non-zero retcode, we attempt to load_dependency
execute unless predicate isomorphic:call_stack/is_pass_return_code run data modify storage isomorphic:temp local.lookup.path set from storage isomorphic:global pm.this.path
execute unless predicate isomorphic:call_stack/is_pass_return_code run function isomorphic:internal/subroutine/load_dependency with storage isomorphic:temp local.lookup

# Load dependency sets local.success_code to a 1 on success.
execute if data storage isomorphic:temp {local:{success_code:0}} run return 1

# Recursively calls until empty or error.
data remove storage isomorphic:global pm.this.dependencies[0]
return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/verify_dependency_list",arguments:{}}
