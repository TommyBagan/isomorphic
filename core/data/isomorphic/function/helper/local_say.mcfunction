### Description:
# This will mimic a player, and locally put a message in chat.
### Usage:
# function isomorphic:helper/local_say {message:<message>}
###

$tellraw @a[distance=..32] [{"text": "<"},{selector:"@s"},{text: "> "},$(message)]