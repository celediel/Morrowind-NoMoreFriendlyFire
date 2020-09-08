local common = require("celediel.NoMoreFriendlyFire.common")
local config = require("celediel.NoMoreFriendlyFire.config").getConfig()

local template = mwse.mcm.createTemplate(common.modName)
template:saveOnClose(common.modConfig, config)

local page = template:createSideBarPage({
    label = "Main options",
    description = string.format("%s v%s by %s\n\n%s", common.modName, common.version, common.author, common.modInfo)
})

local category = page:createCategory(common.modName)

category:createYesNoButton({
    label = "Stop friendly fire",
    variable = mwse.mcm.createTableVariable({id = "enable", table = config})
})

category:createYesNoButton({
    label = "Debug logging",
    variable = mwse.mcm.createTableVariable({id = "debug", table = config})
})

return template
