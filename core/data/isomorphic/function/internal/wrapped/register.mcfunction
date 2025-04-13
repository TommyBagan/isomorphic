### Description:
# This will register an isomorphic datapack, and verify its dependencies are present.
### Usage:
# function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/register",arguments:{name:<string>,path:<string>,dependencies:[<string>,...]}}
###

# Makes a message area so all messages can use
data modify storage isomorphic:temp local.log_msg.datapack set from storage isomorphic:temp local.arguments.name

# Logs out the register message.
data modify storage isomorphic:temp local.log_msg.message.text set value "Attempting to register."
function isomorphic:api/log/trace with storage isomorphic:temp local.log_msg

# Sets up the global object for this datapack. It will be copied later so future registration calls can access the info.
data remove storage isomorphic:global pm.this
data modify storage isomorphic:global pm.this.path set from storage isomorphic:temp local.arguments.path
data modify storage isomorphic:global pm.this.datapack set from storage isomorphic:temp local.arguments.name
data modify storage isomorphic:global pm.this.dependencies set from storage isomorphic:temp local.arguments.dependencies

# Marks as unregistered.
data modify storage isomorphic:global pm.this.registered set value false

# Verifies dependency list.
execute store result storage isomorphic:temp local.return_code int 1 run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/verify_dependency_list",arguments:{}}
data modify storage isomorphic:temp local.saved_return_code set from storage isomorphic:temp local.return_code

# If we was succcessful, we mark as registered.
execute if predicate isomorphic:call_stack/is_pass_return_code run data modify storage isomorphic:global pm.this.registered set value true

# We log appropriately depending on the error.
execute if predicate isomorphic:call_stack/is_pass_return_code run data modify storage isomorphic:temp local.log_msg.message.text set value "Registered successfully."
execute if predicate isomorphic:call_stack/is_pass_return_code run function isomorphic:api/log/trace with storage isomorphic:temp local.log_msg
execute unless predicate isomorphic:call_stack/is_pass_return_code run data modify storage isomorphic:temp local.log_msg.message.text set value "Failed to register!"
execute unless predicate isomorphic:call_stack/is_pass_return_code run function isomorphic:api/log/fatal with storage isomorphic:temp local.log_msg

# Indicates we will archive the pack.
data modify storage isomorphic:temp local.log_msg.message.text set value "Archiving the pack for future reference."
function isomorphic:api/log/debug with storage isomorphic:temp local.log_msg

# Archives the data pack before exiting.
function isomorphic:internal/subroutine/archive_pack with storage isomorphic:temp local.arguments
return run data get storage isomorphic:temp local.saved_return_code 1