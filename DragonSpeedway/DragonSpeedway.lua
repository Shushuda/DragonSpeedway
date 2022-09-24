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


-- event handler frame

DragonSpeedway = CreateFrame("Frame")


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
    }
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
        if self.db.forceMusicSetting then
            globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
            C_CVar.SetCVar("Sound_EnableMusic", 1)
        end
        if self.db.enableMusicVolume then
            globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
            C_CVar.SetCVar("Sound_MusicVolume", self.db.musicVolume)
        end
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