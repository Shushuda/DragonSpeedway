-- global local vars

local addonName, addonVars = ...


-- libraries

local LSM = LibStub("LibSharedMedia-3.0")


-- global methods to be used by main addon

-- generate game group tables
function DragonSpeedway_generateGameTables(hashtable)
    local spyroOneTable = {}
    local spyroTwoTable = {}
    local spyroThreeTable = {}
    local custom = {}
    local sounds = {}

    for key, value in pairs(hashtable) do
        if string.match(value, "^Interface\\Addons\\DragonSpeedway_Music\\Music\\Spyro Reignited 1\\") then
            tinsert(spyroOneTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway_Music\\Music\\Spyro Reignited 2\\") then
            tinsert(spyroTwoTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway_Music\\Music\\Spyro Reignited 3\\") then
            tinsert(spyroThreeTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway_Music\\Music\\Custom\\") then
            tinsert(custom, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway_Music\\Sounds\\") then
            tinsert(sounds, key)
        end
    end
    table.sort(spyroOneTable)
    table.sort(spyroTwoTable)
    table.sort(spyroThreeTable)
    table.sort(custom)
    table.sort(sounds)

    return spyroOneTable, spyroTwoTable, spyroThreeTable, custom, sounds
end

-- generate new defaults
function DragonSpeedway_generateDefaultMusic()
    local defaultBGM = "Harbor Speedway"
    local defaultFinalCDM = "AirHorn Final"
    local defaultCDM = "None"
    local defaultVictoryM = "Tada"

    return defaultBGM, defaultFinalCDM, defaultCDM, defaultVictoryM
end