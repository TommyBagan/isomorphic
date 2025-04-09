### Description:
# This will emit an debug level log for an isomorphic datapack.
### Usage:
# run isomorphic:api/log/debug {datapack:<string>,message:<text_component>}
###

# Early exit if we can't emit the log due to the config definition.
execute unless data storage isomorphic:config {logging:{level:{fatal:{alert:{trace:{debug:{}}}}}}} run return 1

# Outputs the message if the config enables it.
$tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.debug",fallback:"DEBUG",bold:true,color:"gray",hover_event:{action:"show_text",value:{translate:"log.isomorphic.debug.hover"}}},{"text": " [",color:"white",bold:false},{"text":"$(datapack)","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]
return 0