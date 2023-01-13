--------------------------------------------------------------------------------
-- global local vars
--------------------------------------------------------------------------------

local addonName, addonVars = ...

--------------------------------------------------------------------------------
-- libraries
--------------------------------------------------------------------------------

local LSM = LibStub("LibSharedMedia-3.0")

--------------------------------------------------------------------------------
-- slash commands
--------------------------------------------------------------------------------

SLASH_DRAGONSPEEDWAY1, SLASH_DRAGONSPEEDWAY2 = "/dragonspeedway", "/ds"

function SlashCmdList.DRAGONSPEEDWAY(msg, editBox)
    if msg == "stop" then
        print("DragonSpeedway - stopping the music")
        StopMusic()
    else
        InterfaceOptionsFrame_OpenToCategory(DragonSpeedway.category)
        InterfaceOptionsFrame_OpenToCategory(DragonSpeedway.category)
        --Settings.OpenToCategory(DragonSpeedway.category.name)
        --Settings.OpenToCategory(DragonSpeedway.category.name)
    end
end

--------------------------------------------------------------------------------
-- local vars
--------------------------------------------------------------------------------

local dragonRaceSpellId, dragonRacePvPCountdownSpellId = 369968, 392228
local dragonRaceCountdownTimer = 0
local raceInstanceID, raceCountdownInstanceId, racePvPCountdownInstanceId = nil, nil, nil
local globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
local globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
local lastPlayedMusic = nil
local noDefault = false

local dragonRidingMountList = {
    [368899] = true, [360954] = true, [368901] = true, [368896] = true
}

local dragonRaceCountdownSpellIds = {
    [375810] = true, [375261] = true, [392228] = true, [369893] = true, [375236] = true,
    [378430] = true, [386331] = true, [370014] = true, [370326] = true, [370329] = true,
    [370426] = true, [372239] = true, [373495] = true, [373571] = true, [373578] = true,
    [373851] = true, [373857] = true, [374088] = true, [374091] = true, [374143] = true,
    [374144] = true, [374182] = true, [374183] = true, [374244] = true, [374246] = true,
    [374412] = true, [374414] = true, [374592] = true, [374593] = true, [374825] = true,
    [375261] = true, [375262] = true, [375356] = true, [375358] = true, [375477] = true,
    [375479] = true, [376062] = true, [376195] = true, [376366] = true, [376805] = true,
    [376817] = true, [377025] = true, [377026] = true, [377692] = true, [377745] = true,
    [378415] = true, [378753] = true, [378775] = true, [379036] = true, [379397] = true,
    [381978] = true, [382000] = true, [382632] = true, [382652] = true, [382717] = true,
    [382755] = true, [383473] = true, [383474] = true, [383596] = true, [383597] = true,
    [386211] = true, [387548] = true, [387563] = true
}

--------------------------------------------------------------------------------
-- event handler frame
--------------------------------------------------------------------------------

DragonSpeedway = CreateFrame("Frame")

--------------------------------------------------------------------------------
-- local functions
--------------------------------------------------------------------------------

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

local function tableContains(table, key)
    return table[key] ~= nil
end

--------------------------------------------------------------------------------
-- class methods
--------------------------------------------------------------------------------

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

-- generate defaults for db
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
        enableSkywardAscentSound = false,
        enableSurgeForwardSound = false,
        enableWhirlingSurgeSound = false,
        enableBronzeRewindSound = false,
        musicVolume = 100,
        enableMusicVolume = false,
        forceMusicSetting = false,
        randomMusic = 'All',
        enableRandomMusic = false,
        skywardAscentSound = defaultFinalCDM,
        surgeForwardSound = defaultFinalCDM,
        whirlingSurgeSound = defaultFinalCDM,
        bronzeRewindSound = defaultFinalCDM,
        cameraDistance = 100,
        enableCameraDistance = false,
        enableMountCameraDistance = false,
        musicRacesSetting = true,
        spellRacesSetting = true,
        cameraRacesSetting = true,
        volumeRacesSetting = true,
        forceMusicRacesSetting = true,
        globalCameraDistance = 0,
        mountInstanceID = nil,
        defMusicRacesSetting = false,
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

function DragonSpeedway:setCameraDistance(level)
    local zoom = GetCameraZoom()
    local delta = zoom - level
    if delta > 0 then
        CameraZoomIn(delta)
    else
        CameraZoomOut(-delta)
    end
end

--------------------------------------------------------------------------------
-- event handler methods
--------------------------------------------------------------------------------

function DragonSpeedway:handleAuraUpdate(unitAuraUpdateInfo)
    -- remember race aura instance IDs
    -- and handle the sound start-up
    if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            if aura.spellId == dragonRaceSpellId then
                raceInstanceID = aura.auraInstanceID
                self:handleDragonRaceStart()
            elseif tableContains(dragonRaceCountdownSpellIds, aura.spellId) then
                self:handleDragonRaceCountdown()
            elseif tableContains(dragonRidingMountList, aura.spellId) then
                -- failsafe in case game registers aura on login
                local skipZoom = false
                if self.db.mountInstanceID then
                    skipZoom = true
                end
                self.db.mountInstanceID = aura.auraInstanceID
                self:handleDragonridingMount(skipZoom)
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
            elseif auraInstanceID == self.db.mountInstanceID then
                self.db.mountInstanceID = nil
                self:handleDragonridingDismount()
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

function DragonSpeedway:handleDragonRaceCountdown()
    if self.db.enableCameraDistance then
        self.db.globalCameraDistance = GetCameraZoom()
        self:setCameraDistance(self.db.cameraDistance)
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
    if self.db.enableCameraDistance then
        self:setCameraDistance(self.db.globalCameraDistance)
    end
    if self.db.defMusicRacesSetting then
        -- default dragonriding music
        -- sound/music/dragonflight/mus_100_dragonrace_h.mp3
        PlayMusic(4887933)
    end
end

function DragonSpeedway:handleDragonridingMount(skipZoom)
    if self.db.enableMountCameraDistance
    and not self.db.enableCameraDistance then
        if not skipZoom then
            self.db.globalCameraDistance = GetCameraZoom()
        end
        self:setCameraDistance(self.db.cameraDistance)
    end
    if self.db.defMusicRacesSetting then
        -- default dragonriding music
        -- sound/music/dragonflight/mus_100_dragonrace_h.mp3
        PlayMusic(4887933)
    end
end

function DragonSpeedway:handleDragonridingDismount()
    if self.db.enableMountCameraDistance
    and not self.db.enableCameraDistance then
        self:setCameraDistance(self.db.globalCameraDistance)
    end
    StopMusic()
end

function DragonSpeedway:reapplyMountDismount()
    local mountAura = nil
    for spellID, _ in pairs(dragonRidingMountList) do
        mountAura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
        if mountAura then break end
    end
    if mountAura then
        self.db.mountInstanceID = mountAura.auraInstanceID
        self:handleDragonridingMount(true)
    else
        -- player is not mounted
        if self.db.mountInstanceID then
            -- but there is an instance ID
            -- clean it and reapply dismount camera
            self.db.mountInstanceID = nil
            self:handleDragonridingDismount()
        end
        -- no instance ID -> no mount aura means player ported from unmounted
        -- into unmounted state, so nothing to do here
    end
end

--------------------------------------------------------------------------------
-- event handler event methods
--------------------------------------------------------------------------------

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

    if unitAuraUpdateInfo then
        self:handleAuraUpdate(unitAuraUpdateInfo)
    end
end

-- loading into places while mounted can confuse aura events
-- happens also when leaving instances into a mounted state
-- workaround by manually checking for mount status on each loading screen
-- this also takes care of login issue with losing spell instance IDs
function DragonSpeedway:LOADING_SCREEN_DISABLED(event, ...)
    -- schedule in 2sec to make sure it grabs the ID
    addonVars.SchedulerLib:ScheduleUniqueTask(2, self.reapplyMountDismount, self)
end

--------------------------------------------------------------------------------
-- register events and listen
--------------------------------------------------------------------------------

DragonSpeedway:RegisterEvent("ADDON_LOADED")
DragonSpeedway:RegisterEvent("UNIT_AURA")
DragonSpeedway:RegisterEvent("LOADING_SCREEN_DISABLED")


DragonSpeedway:SetScript("OnEvent", DragonSpeedway.OnEvent)
