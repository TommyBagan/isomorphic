# Defaults logging to emit for fatal errors & alerts
execute unless data storage isomorphic:config {logging:{level:{fatal:{}}}} run data modify storage isomorphic:config logging.level.fatal.alert.trace set value {}
