local common = require("celediel.NoMoreFriendlyFire.common")
local config = require("celediel.NoMoreFriendlyFire.config").getConfig()

local mag
pcall(function() mag = require("celediel.MoreAttentiveGuards.interop") end)

-- todo: make this not hardcoded somehow
local followMatches = {"follow", "together", "travel", "wait", "stay"}
local postDialogueTimer

local function log(...) if config.debug then mwse.log("[%s] %s", common.modName, string.format(...)) end end

-- keep track of followers
local followers = {}

local function friendCheck(friend)
    if not friend then return false end

    -- first try baseObject, then try object.baseObject, finally settle on object
    local obj = friend.baseObject and friend.baseObject or
                    (friend.object.baseObject and friend.object.baseObject or friend.object)

    -- ignored More Attentive Guards followers
    local magGuard = mag and mag.getGuardFollower() or nil
    if friend == magGuard then
        log("Ignored MAG Guard %s", obj.name)
        return false
    end

    -- ignored id
    if config.ignored[obj.id:lower()] then
        log("Ignored id %s", obj.id)
        return false
    end

    -- ignored mod
    if config.ignored[obj.sourceMod:lower()] then
        log("Ignored mod %s", obj.sourceMod)
        return false
    end

    -- otherwise,
    return true
end

local function followerDamageCheck(attacker, attackee)
    return followers[attacker.object.id] ~= nil and followers[attackee.object.id] ~= nil and attacker ~= attackee
end

local function buildFollowerList()
    local friends = {}

    local msg = ""

    for friend in tes3.iterate(tes3.mobilePlayer.friendlyActors) do
        if friendCheck(friend) then
            friends[friend.object.id] = true
            msg = msg .. friend.object.name .. " "
        end
    end
    if msg ~= "" then log("Friends: %s", msg) end
    return friends
end

-- Event functions
local eventFunctions = {}

eventFunctions.onDamage = function(e)
    if not e.attackerReference then return end

    if followerDamageCheck(e.attackerReference, e.reference) then
        if config.enable then
            log("%s hit %s for %s friendly damage, nullifying", e.attackerReference.object.name,
                e.reference.object.name, e.damage)
            e.damage = 0
            return false -- I don't know if this makes a difference or not
        else
            log("%s hit %s for %s friendly damage", e.attackerReference.object.name, e.reference.object.name, e.damage)
        end
    -- uncomment this to see all damage done by everyone to everyone else
    -- else
    --     log("%s hit %s for %s damage", e.attackerReference.object.name, e.reference.object.name, e.damage)
    end
end

eventFunctions.onCellChanged = function(e) followers = buildFollowerList() end

-- hopefully, when telling a follower to follow or wait, rebuild followers list
eventFunctions.onInfoResponse = function(e)
    -- the dialogue option clicked on
    local dialogue = tostring(e.dialogue):lower()
    -- what that dialogue option triggers; this will catch AIFollow commands
    local command = e.command:lower()

    for _, item in pairs(followMatches) do
        if command:match(item) or dialogue:match(item) then
            log("Found %s in dialogue, rebuilding followers", item)
            -- wait until game time restarts, and don't set multiple timers
            if not postDialogueTimer or postDialogueTimer.state ~= timer.active then
                postDialogueTimer = timer.start({
                    type = timer.simulate,
                    duration = 0.5,
                    iteration = 1,
                    callback = function() followers = buildFollowerList() end
                })
            end
        end
    end
end

-- rebuild followers list when player casts conjuration, in case its a summon spell
-- false positives are okay because we're not doing anything destructive
eventFunctions.onSpellCasted = function(e)
    if e.caster == tes3.player and e.expGainSchool == tes3.magicSchool.conjuration then
        log("Player cast conjuration spell %s, rebuilding followers list...", e.source.id)
        -- wait for summon to be loaded
        timer.start({
            type = timer.simulate,
            duration = 1,
            iterations = 1,
            callback = function() followers = buildFollowerList() end
        })
    end
end

-- Register events
local function onInitialized()
    for name, func in pairs(eventFunctions) do
        event.register(name:gsub("on(%u)", string.lower), func)
        log("%s event registered", name)
    end

    mwse.log("[%s] Successfully initialized%s", common.modName, mag and " with More Attentive Guards interop" or "")
end

event.register("modConfigReady", function() mwse.mcm.register(require("celediel.NoMoreFriendlyFire.mcm")) end)
event.register("initialized", onInitialized)
