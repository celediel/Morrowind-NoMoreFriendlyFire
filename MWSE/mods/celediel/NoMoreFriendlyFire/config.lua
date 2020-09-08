local common = require("celediel.NoMoreFriendlyFire.common")

local currentConfig
local defaultConfig = {enable = true, debug = false}
local this = {}

this.getConfig = function()
    currentConfig = currentConfig or mwse.loadConfig(common.modConfig, defaultConfig)
    return currentConfig
end

return this
