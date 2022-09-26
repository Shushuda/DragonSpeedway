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
        Settings.OpenToCategory(DragonSpeedway.category.name)
    end
end


-- local vars

local dragonRaceSpellId, dragonRaceCountdownSpellId, dragonRacePvPCountdownSpellId = 369968, 392559, 392228
local dragonRaceCountdownTimer = 0
local raceInstanceID, raceCountdownInstanceId, racePvPCountdownInstanceId = nil, nil, nil
local globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
local globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
local lastPlayedMusic = nil
local noDefault = false


-- event handler frame

DragonSpeedway = CreateFrame("Frame")


-- local functions

local function isRandomizableTable(table)
    if #table == 1 or #table == 0 then
        return false
    else
        return true
    end
end

local function isEmptyTable(table)
    if #table == 0 then
        return true
    else
        return false
    end
end


-- class methods

-- generate game group tables
function DragonSpeedway:generateGameTables()
    local spyroOneTable, spyroTwoTable, spyroThreeTable, custom, sounds = {}, {}, {}, {}, {}

    spyroOneTable, spyroTwoTable, spyroThreeTable, custom, sounds = DragonSpeedway_generateGameTables(self.hashtable)

    addonVars.spyroOneTable = spyroOneTable
    addonVars.spyroTwoTable = spyroTwoTable
    addonVars.spyroThreeTable = spyroThreeTable
    addonVars.custom = custom
    addonVars.sounds = sounds
    
    addonVars.randomGroups = {
        ['All'] = 'All',
        ['Spyro'] = 'Spyro',
        ['Custom'] = 'Custom',
    }
    addonVars.randomGroupsKeys = {}
    
    local len = 0
    for key, _ in pairs(addonVars.randomGroups) do
        len = len + 1
        addonVars.randomGroupsKeys[len] = key
    end
    
    table.sort(addonVars.randomGroupsKeys)

    addonVars.spyroEverythingTable = {}
    addonVars.musicEverythingTable = {}

    local n = 0
    for key, value in ipairs(addonVars.spyroOneTable) do
        n = n + 1
        addonVars.spyroEverythingTable[n] = value
        addonVars.musicEverythingTable[n] = value
    end
    
    for key, value in ipairs(addonVars.spyroTwoTable) do
        n = n + 1
        addonVars.spyroEverythingTable[n] = value
        addonVars.musicEverythingTable[n] = value
    end
    
    for key, value in ipairs(addonVars.spyroThreeTable) do
        n = n + 1
        addonVars.spyroEverythingTable[n] = value
        addonVars.musicEverythingTable[n] = value
    end

    for key, value in ipairs(addonVars.custom) do
        n = n + 1
        addonVars.musicEverythingTable[n] = value
    end

end

function DragonSpeedway:generateDefaults()
    local defaultBGM, defaultFinalCDM, defaultCDM, defaultVictoryM = {}, {}, {}, {}

    defaultBGM, defaultFinalCDM, defaultCDM, defaultVictoryM = DragonSpeedway_generateDefaultMusic()

    self.defaults = {
        music = defaultBGM,
        countdownSound = defaultCDM,
        countdownFinalSound = defaultFinalCDM,
        victorySound = defaultVictoryM,
        enableMusic = true,
        enableCountdownSound = true,
        enableCountdownFinalSound = true,
        enableVictorySound = true,
        musicVolume = 100,
        enableMusicVolume = false,
        forceMusicSetting = false,
        randomMusic = 'All',
        enableRandomMusic = false,
    }
end

function DragonSpeedway:getRandomMusic()
    local randomMusic, isRandomizable = nil, false

    -- keep getting songs until it's a different one than last
    -- unless the table is too small to pick anything new (1 or 0 elem)
    repeat
        randomMusic, isRandomizable = self:getRandomMusicFromGroup()
    until(randomMusic ~= lastPlayedMusic or isRandomizable == false)
    lastPlayedMusic = randomMusic

    return randomMusic
end

function DragonSpeedway:getRandomMusicFromGroup()
    local randomMusic, isRandomizable = nil, false

    if self.db.randomMusic == addonVars.randomGroups['Spyro'] then
        randomMusic, isRandomizable = self:getRandomMusicAndAmount(addonVars.spyroEverythingTable)
    elseif self.db.randomMusic == addonVars.randomGroups['Custom'] then
        randomMusic, isRandomizable = self:getRandomMusicAndAmount(addonVars.custom)
    elseif self.db.randomMusic == addonVars.randomGroups['All'] then
        randomMusic, isRandomizable = self:getRandomMusicAndAmount(addonVars.musicEverythingTable)
    end

    return randomMusic, isRandomizable
end

-- return nil if the table has no music
-- return a random song otherwise
-- check if the table can be randomized (has more than 1 element)
function DragonSpeedway:getRandomMusicAndAmount(table)
    if isEmptyTable(table) then
        randomMusic = nil
    else
        randomMusic = table[math.random(#table)]
    end
    isRandomizable = isRandomizableTable(table)

    return randomMusic, isRandomizable
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
            if aura.spellId == dragonRaceCountdownSpellId or aura.spellId == dragonRacePvPCountdownSpellId then
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
        local bgm = nil

        if self.db.forceMusicSetting then
            globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
            C_CVar.SetCVar("Sound_EnableMusic", 1)
        end
        if self.db.enableMusicVolume then
            globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
            C_CVar.SetCVar("Sound_MusicVolume", self.db.musicVolume)
        end
        if self.db.enableRandomMusic then
            bgm = LSM:Fetch("sound", self:getRandomMusic(), noDefault)
        else
            bgm = LSM:Fetch("sound", self.db.music, noDefault)
        end
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
    if self.db.forceMusicSetting then
        C_CVar.SetCVar("Sound_EnableMusic", globalMusicEnable)
    end
    if self.db.enableMusicVolume then
        C_CVar.SetCVar("Sound_MusicVolume", globalMusicVolume)
    end
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
        print(addOnName, "loaded. Type '/ds' for settings or '/ds stop' for stopping the currently playing music")
        
        -- initialize saved variables
        DragonSpeedwayDB = DragonSpeedwayDB or {}
        self.db = DragonSpeedwayDB

        self:generateDefaults()

        for key, value in pairs(self.defaults) do
            if self.db[key] == nil then
                self.db[key] = value
            end
        end
        
        -- build hashtable of sounds
        self.hashtable = LSM:HashTable("sound")
        
        -- validate sounds
        if not LSM:IsValid("sound") then
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
