### Description:
# This will emit a tellraw command with a message component.
### Usage:
# function isomorphic:internal/subroutine/emit_tellraw_by_level {message:<text_component>}
### Assumes:
# local.arguments.datapack is set to string
# local.arguments.level is set to an int
###

# Uses macro expansion to substitute in a message component.
$execute if predicate isomorphic:logging/is_debug_log run tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.debug",fallback:"DEBUG",bold:true,color:"gray",hover_event:{action:"show_text",value:{translate:"log.isomorphic.debug.hover"}}},{"text": " [",color:"white",bold:false},{nbt:"local.arguments.datapack",storage:"isomorphic:temp","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]
$execute if predicate isomorphic:logging/is_trace_log run tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.trace",fallback:"TRACE",bold:true,color:"white",hover_event:{action:"show_text",value:{translate:"log.isomorphic.trace.hover"}}},{"text":" [",color:"white",bold:false},{nbt:"local.arguments.datapack",storage:"isomorphic:temp",color:"green"},{"text":"]: ",color:"white",bold:false},$(message)]
$execute if predicate isomorphic:logging/is_alert_log run tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.alert",fallback:"ALERT",bold:true,color:"yellow",hover_event:{action:"show_text",value:{translate:"log.isomorphic.alert.hover"}}},{"text": " [",color:"white",bold:false},{nbt:"local.arguments.datapack",storage:"isomorphic:temp","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]
$execute if predicate isomorphic:logging/is_fatal_log run tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.fatal",fallback:"FATAL",bold:true,color:"red",hover_event:{action:"show_text",value:{translate:"log.isomorphic.fatal.hover"}}},{"text": " [",color:"white",bold:false},{nbt:"local.arguments.datapack",storage:"isomorphic:temp","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]
$execute if predicate isomorphic:logging/is_abort_log run tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.abort",fallback:"ABORT",bold:true,color:"light_purple",hover_event:{action:"show_text",value:{translate:"log.isomorphic.abort.hover"}}},{"text": " [",color:"white",bold:false},{nbt:"local.arguments.datapack",storage:"isomorphic:temp","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]