### Description:
# This will register an isomorphic datapack, and verify its dependencies are present.
### Usage:
# function isomorphic:api/register {name:<string>,path:<string>,dependencies:[<string>,...]}
###

$return run function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/register",arguments:{name:"$(name)",path:"$(path)",dependencies:$(dependencies)}}