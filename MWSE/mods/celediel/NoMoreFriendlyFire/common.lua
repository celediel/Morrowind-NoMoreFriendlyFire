local this = {}

-- mod info variables
this.modName = "No More Friendly Fire"
this.modConfig = this.modName:gsub("%s", "")
this.modInfo = "Stop friendly fire. Player companions can't damage the player, the player " ..
               "can't damage companions, and companions can't damage each other. That's it."
this.author = "Celediel"
this.version = "1.2.1"

return this
