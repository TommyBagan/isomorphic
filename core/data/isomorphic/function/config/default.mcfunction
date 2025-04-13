
### Description:
# This will reset the config to its default rules.
### Usage:
# function isomorphic:config/reset
###

function isomorphic:api/call {namespace:"isomorphic",function:"internal/wrapped/init_config",arguments:{force:true}}