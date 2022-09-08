-- global local vars

local addonName, addonVars = ...


-- libraries

local LSM = LibStub("LibSharedMedia-3.0")


-- slash commands

SLASH_DRAGONSPEEDWAY1, SLASH_DRAGONSPEEDWAY2 = "/dragonspeedway", "/ds"

function SlashCmdList.DRAGONSPEEDWAY(msg, editBox)
    if msg == "stop" then
        print("DragonSpeedway - stopping the music")
        StopMusic()
    else
        -- https://github.com/Stanzilla/WoWUIBugs/issues/89
        Settings.OpenToCategory(DragonSpeedway.category.name)
        Settings.OpenToCategory(DragonSpeedway.category.name)
    end
end


-- local vars

local dragonRaceSpellId, dragonRaceCountdownSpellId = 183117, 192106 -- TODO: Replace with correct IDs
local dragonRaceCountdownTimer = 0
local raceInstanceID, raceCountdownInstanceId = nil, nil


-- event handler frame

DragonSpeedway = CreateFrame("Frame")


-- class methods

-- generate game group tables
function DragonSpeedway:generateGameTables()
    addonVars.spyroOneTable = {}
    addonVars.spyroTwoTable = {}
    addonVars.spyroThreeTable = {}
    addonVars.custom = {}
    addonVars.sounds = {}
    
    for key, value in pairs(self.hashtable) do
        if string.match(value, "^Interface\\Addons\\DragonSpeedway\\Music\\Spyro Reignited 1\\") then
            tinsert(addonVars.spyroOneTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway\\Music\\Spyro Reignited 2\\") then
            tinsert(addonVars.spyroTwoTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway\\Music\\Spyro Reignited 3\\") then
            tinsert(addonVars.spyroThreeTable, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway\\Music\\Custom\\") then
            tinsert(addonVars.custom, key)
        elseif string.match(value, "^Interface\\Addons\\DragonSpeedway\\Sounds\\") then
            tinsert(addonVars.sounds, key)
        end
    end
    table.sort(addonVars.spyroOneTable)
    table.sort(addonVars.spyroTwoTable)
    table.sort(addonVars.spyroThreeTable)
    table.sort(addonVars.custom)
    table.sort(addonVars.sounds)
    
end


-- event handler methods

function DragonSpeedway:handleAuraUpdate(unitAuraUpdateInfo)
    -- remember race and countdown aura instance IDs
    -- and handle the sound start-up
    if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            if aura.spellId == dragonRaceSpellId then
                raceInstanceID = aura.auraInstanceID
                self:handleDragonRaceStart()
            end
            if aura.spellId == dragonRaceCountdownSpellId then
                raceCountdownInstanceId = aura.auraInstanceID
                self:handleDragonRaceCountdown()
            end
        end
        
    end
    
    -- check if removed auras include the remembered race instance ID
    -- and handle the sound stop
    if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
            if auraInstanceID == raceInstanceID then
                raceInstanceID = nil
                self:handleDragonRaceEnd()
            end
        end
    end
end

function DragonSpeedway:handleDragonRaceStart()
    if self.db.enableMusic then
        local bgm = LSM:Fetch("sound", self.db.music, noDefault)
        PlayMusic(bgm)
    end
    if self.db.enableCountdownFinalSound then
        local cdm = LSM:Fetch("sound", self.db.countdownFinalSound, noDefault)
        PlaySoundFile(cdm, "SFX")
    end
end

function DragonSpeedway:handleDragonRaceEnd()
    if self.db.enableVictorySound then
        local victory = LSM:Fetch("sound", self.db.victorySound, noDefault)
        PlaySoundFile(victory, "SFX")
    end
    StopMusic()
end

function DragonSpeedway:handleDragonRaceCountdown()
    -- TODO: Implement countdown 2, 1
    -- 2 and 1 have the same sound
    -- find this sound x.x
    --print("The buff was the Lightning Shield!") -- debug
    -- debug
    if self.db.enableCountdownSound then
        --print("countdown sound enabled")
    else
        --print("countdown sound disabled")
    end
end


-- event handler event methods

function DragonSpeedway:OnEvent(event, ...)
	self[event](self, event, ...)
end

function DragonSpeedway:ADDON_LOADED(event, addOnName)
	if addOnName == "DragonSpeedway" then
        print(addOnName, "loaded. Type '/ds' for settings or '/ds stop' for stopping the music")
        
        -- initialize saved variables
        DragonSpeedwayDB = DragonSpeedwayDB or {}
        self.db = DragonSpeedwayDB
        for key, value in pairs(self.defaults) do
            if self.db[key] == nil then
                self.db[key] = value
            end
        end
        
        -- build hashtable of sounds
        self.hashtable = LSM:HashTable("sound")
        
        -- validate sounds
        if LSM:IsValid("sound") then
            print(addOnName, "- all music validated. Happy Racing!")
        else
            print(addOnName, "- failed music validation! Check your files!")
        end
        
        self:generateGameTables()
        
        -- initialize options
        self:InitializeOptions()
        self:UnregisterEvent(event)
    end
end

function DragonSpeedway:UNIT_AURA(event, ...)
    local unitTarget, unitAuraUpdateInfo = ...
    
    if unitTarget ~= "player" then
        return
    end
    
    --print("Some buffs changed somewhere") -- debug
    
    if unitAuraUpdateInfo then
        self:handleAuraUpdate(unitAuraUpdateInfo)
    end
end


-- register events and listen

DragonSpeedway:RegisterEvent("ADDON_LOADED")
DragonSpeedway:RegisterEvent("UNIT_AURA")


DragonSpeedway:SetScript("OnEvent", DragonSpeedway.OnEvent)
