### Description:
# This will emit an abort level log for an isomorphic datapack.
### Usage:
# run isomorphic:api/log/abort {datapack:<string>,message:<text_component>}
###

$tellraw @a [{"translate":"",color:"white",bold:false},{translate:"log.isomorphic.abort",fallback:"ABORT",bold:true,color:"light_purple",hover_event:{action:"show_text",value:{translate:"log.isomorphic.abort.hover"}}},{"text": " [",color:"white",bold:false},{"text":"$(datapack)","color":"green"},{"text":"]: ",color:"white",bold:false},$(message)]
return 0