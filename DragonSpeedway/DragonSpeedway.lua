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
        Settings.OpenToCategory(DragonSpeedway.category.name)
    end
end

--------------------------------------------------------------------------------
-- local vars
--------------------------------------------------------------------------------

local dragonRaceSpellId, dragonRacePvPCountdownSpellId = 369968, 392228
local dragonRaceCountdownTimer = 0
local raceInstanceID, raceCountdownInstanceID, racePvPCountdownInstanceID = nil, nil, nil
local globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
local globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
local lastPlayedMusic = nil
local noDefault = false

local defaults = {
    profile = {
        -- User preferences (switchable between profiles)
        -- Sound defaults set to nil, populated after LSM loads
        music = nil,
        countdownSound = nil,
        countdownFinalSound = nil,
        victorySound = nil,
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
        skywardAscentSound = nil,
        surgeForwardSound = nil,
        whirlingSurgeSound = nil,
        bronzeRewindSound = nil,
        cameraDistance = 39,
        enableCameraDistance = false,
        enableMountCameraDistance = false,
        musicRacesSetting = true,
        spellRacesSetting = true,
        cameraRacesSetting = true,
        volumeRacesSetting = true,
        forceMusicRacesSetting = true,
        defMusicRacesSetting = false,
    },
    char = {
        -- Per-character state (not switchable)
        globalCameraDistance = 0,
        isMountedWithGlide = false,
    },
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
    [386211] = true, [387548] = true, [387563] = true, [395088] = true, [396688] = true,
    [396710] = true, [396712] = true, [396714] = true, [396934] = true, [396943] = true,
    [396960] = true, [396977] = true, [396984] = true, [396997] = true, [397050] = true,
    [397129] = true, [397131] = true, [397141] = true, [397143] = true, [397147] = true,
    [397151] = true, [397155] = true, [397157] = true, [397175] = true, [397179] = true,
    [397182] = true, [397187] = true, [397189] = true, [398264] = true, [398326] = true,
    [398228] = true, [398213] = true, [398141] = true, [398123] = true, [398113] = true,
    [398049] = true, [398027] = true, [398408] = true, [398116] = true, [398100] = true,
    [398054] = true, [398428] = true, [398107] = true, [398034] = true, [398309] = true,
    [404002] = true, [403729] = true, [403898] = true, [404558] = true, [403192] = true,
    [403502] = true, [403533] = true, [403795] = true, [403884] = true, [403934] = true,
    [404640] = true, [404644] = true, [403205] = true, [403679] = true, [403746] = true,
    [403784] = true, [403830] = true, [403992] = true, [409738] = true, [410864] = true,
    [411318] = true, [411335] = true, [409759] = true, [411315] = true, [417606] = true,
    [418143] = true, [409713] = true, [409758] = true, [409761] = true, [409787] = true,
    [409793] = true, [409797] = true, [409800] = true, [409802] = true, [409811] = true,
    [409812] = true, [409817] = true, [409820] = true, [409859] = true, [409866] = true,
    [410753] = true, [410754] = true, [410755] = true, [410855] = true, [410863] = true,
    [411317] = true, [411322] = true, [411323] = true, [411336] = true, [411338] = true,
    [417226] = true, [417604] = true, [417758] = true, [417870] = true, [417949] = true,
    [418028] = true, [418144] = true, [420157] = true, [409768] = true, [409780] = true,
    [409786] = true, [409791] = true, [409792] = true, [409796] = true, [409799] = true,
    [409807] = true, [409815] = true, [409818] = true, [409857] = true, [409861] = true,
    [409863] = true, [409864] = true, [409865] = true, [409867] = true, [410748] = true,
    [410750] = true, [410751] = true, [410757] = true, [410758] = true, [410854] = true,
    [410856] = true, [410858] = true, [410859] = true, [410860] = true, [410862] = true,
    [411311] = true, [411314] = true, [411316] = true, [411320] = true, [411331] = true,
    [411337] = true, [411339] = true, [411343] = true, [417043] = true, [417230] = true,
    [417869] = true, [417871] = true, [417948] = true, [418026] = true, [418027] = true,
    [418287] = true, [418288] = true, [418289] = true, [418461] = true, [418466] = true,
    [420158] = true, [409760] = true, [409763] = true, [409766] = true, [409778] = true,
    [409782] = true, [409783] = true, [409794] = true, [409801] = true, [409803] = true,
    [409804] = true, [409808] = true, [409814] = true, [409821] = true, [409855] = true,
    [409860] = true, [409862] = true, [409868] = true, [410749] = true, [410756] = true,
    [411312] = true, [411325] = true, [411326] = true, [411327] = true, [411329] = true,
    [411332] = true, [411333] = true, [411334] = true, [411340] = true, [411341] = true,
    [411342] = true, [411345] = true, [411346] = true, [417042] = true, [417231] = true,
    [417605] = true, [417760] = true, [417761] = true, [417950] = true, [418142] = true,
    [418465] = true, [419432] = true, [419433] = true, [419434] = true, [419679] = true,
    [419680] = true, [419681] = true, [420159] = true, [409762] = true, [409774] = true,
    [409775] = true, [410752] = true, [410759] = true, [410853] = true, [410857] = true,
    [410861] = true, [411319] = true, [411330] = true, [411347] = true, [417044] = true,
    [406420] = true, [406440] = true, [406768] = true, [406944] = true, [406297] = true,
    [406422] = true, [407215] = true, [407216] = true, [407531] = true, [407620] = true,
    [407621] = true, [407757] = true, [413655] = true, [406294] = true, [406398] = true,
    [406421] = true, [406438] = true, [406439] = true, [406508] = true, [406696] = true,
    [406697] = true, [406698] = true, [406800] = true, [406923] = true, [406925] = true,
    [406943] = true, [407214] = true, [407595] = true, [407717] = true, [407758] = true,
    [413778] = true, [413779] = true, [413851] = true, [413966] = true, [414017] = true,
    [414018] = true, [414351] = true, [414374] = true, [414740] = true, [414741] = true,
    [414742] = true, [414755] = true, [414756] = true, [414831] = true, [414892] = true,
    [414893] = true, [406257] = true, [406401] = true, [406506] = true, [406507] = true,
    [406766] = true, [406767] = true, [406799] = true, [406801] = true, [406924] = true,
    [406945] = true, [407529] = true, [407593] = true, [407594] = true, [407718] = true,
    [407756] = true, [413852] = true, [413940] = true, [413942] = true, [413967] = true,
    [414349] = true, [414368] = true, [414372] = true, [414751] = true, [414773] = true,
    [414775] = true, [414829] = true, [414891] = true, [406400] = true, [407530] = true,
    [407619] = true, [407719] = true, [413690] = true, [413695] = true, [413780] = true,
    [413854] = true, [413941] = true, [413968] = true, [414016] = true, [414350] = true,
    [414616] = true, [414617] = true, [414618] = true, [414830] = true, [414774] = true,
    [421060] = true, [420742] = true, [420965] = true, [420917] = true, [420975] = true,
    [420988] = true,
    [422017] = true, [406234] = true, [421438] = true, [421451] = true, [422015] = true,
    [422021] = true, [422174] = true, [422178] = true, [422403] = true, [423380] = true,
    [423577] = true, [425741] = true, [426040] = true, [426584] = true, [421439] = true,
    [421452] = true, [422020] = true, [422176] = true, [422400] = true, [423378] = true,
    [423381] = true, [423383] = true, [423562] = true, [423568] = true, [423579] = true,
    [425090] = true, [425091] = true, [425092] = true, [425334] = true, [425335] = true,
    [425449] = true, [425450] = true, [425597] = true, [425598] = true, [425740] = true,
    [425742] = true, [426038] = true, [426039] = true, [426109] = true, [426110] = true,
    [426111] = true, [426349] = true, [426583] = true, [427231] = true, [427234] = true,
    [421437] = true, [422018] = true, [422175] = true, [422179] = true, [422401] = true,
    [422402] = true, [422404] = true, [423382] = true, [423580] = true, [425333] = true,
    [425452] = true, [425601] = true, [426347] = true, [426348] = true, [426585] = true,
    [427235] = true, [431834] = true, [431833] = true, [431835] = true, [431898] = true,
    [431899] = true, [431900] = true,
    [439234] = true, [439250] = true, [439254] = true, [439258] = true, [439268] = true,
    [439271] = true, [439272] = true, [439274] = true, [439288] = true, [439291] = true,
    [439294] = true, [439302] = true, [439318] = true, [439319] = true, [415587] = true,
    [439244] = true, [439301] = true, [439310] = true, [439311] = true, [439233] = true,
    [439235] = true, [439236] = true, [439238] = true, [439239] = true, [439241] = true,
    [439243] = true, [439245] = true, [439246] = true, [439247] = true, [439248] = true,
    [439249] = true, [439251] = true, [439252] = true, [439257] = true, [439260] = true,
    [439261] = true, [439262] = true, [439263] = true, [439265] = true, [439266] = true,
    [439267] = true, [439269] = true, [439270] = true, [439273] = true, [439275] = true,
    [439276] = true, [439277] = true, [439278] = true, [439281] = true, [439282] = true,
    [439283] = true, [439284] = true, [439286] = true, [439287] = true, [439289] = true,
    [439290] = true, [439292] = true, [439293] = true, [439295] = true, [439296] = true,
    [439298] = true, [439300] = true, [439303] = true, [439304] = true, [439305] = true,
    [439307] = true, [439308] = true, [439309] = true, [439313] = true, [439316] = true,
    [439317] = true, [439320] = true, [439321] = true,
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

-- set dynamic sound defaults (called after LSM is available)
function DragonSpeedway:setDynamicDefaults()
    local defaultBGM, defaultFinalCDM, defaultCDM, defaultVictoryM = DragonSpeedway_generateDefaultMusic()

    -- only set if not already configured by user
    if not self.db.profile.music then
        self.db.profile.music = defaultBGM
    end
    if not self.db.profile.countdownSound then
        self.db.profile.countdownSound = defaultCDM
    end
    if not self.db.profile.countdownFinalSound then
        self.db.profile.countdownFinalSound = defaultFinalCDM
    end
    if not self.db.profile.victorySound then
        self.db.profile.victorySound = defaultVictoryM
    end
    if not self.db.profile.skywardAscentSound then
        self.db.profile.skywardAscentSound = defaultFinalCDM
    end
    if not self.db.profile.surgeForwardSound then
        self.db.profile.surgeForwardSound = defaultFinalCDM
    end
    if not self.db.profile.whirlingSurgeSound then
        self.db.profile.whirlingSurgeSound = defaultFinalCDM
    end
    if not self.db.profile.bronzeRewindSound then
        self.db.profile.bronzeRewindSound = defaultFinalCDM
    end
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

    if self.db.profile.randomMusic == addonVars.randomGroups['Spyro'] then
        randomMusic, isRandomizable = self:getRandomMusicAndAmount(addonVars.spyroEverythingTable)
    elseif self.db.profile.randomMusic == addonVars.randomGroups['Custom'] then
        randomMusic, isRandomizable = self:getRandomMusicAndAmount(addonVars.custom)
    elseif self.db.profile.randomMusic == addonVars.randomGroups['All'] then
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
    -- bail out in restricted contexts where aura spellId access is blocked
    if InCombatLockdown() or IsInInstance() then
        return
    end

    -- remember race aura instance IDs
    -- and handle the sound start-up
    if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            if aura.spellId == dragonRaceSpellId then
                raceInstanceID = aura.auraInstanceID
            elseif tableContains(dragonRaceCountdownSpellIds, aura.spellId) then
                raceCountdownInstanceID = aura.auraInstanceID
                -- we don't need to set the camera distance again since
                -- the race is technically still ongoing
                if raceInstanceID then
                    self:handleDragonRaceRestart()
                else
                    self:handleDragonRaceCountdown()
                end
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
            elseif auraInstanceID == raceCountdownInstanceID then
                raceCountdownInstanceID = nil
                self:handleDragonRaceStart()
            end
        end
    end
end

function DragonSpeedway:handleDragonRaceStart()
    if self.db.profile.enableMusic then
        local bgm = nil

        if self.db.profile.forceMusicSetting then
            globalMusicEnable = C_CVar.GetCVar("Sound_EnableMusic")
            C_CVar.SetCVar("Sound_EnableMusic", 1)
        end
        if self.db.profile.enableMusicVolume then
            globalMusicVolume = C_CVar.GetCVar("Sound_MusicVolume")
            C_CVar.SetCVar("Sound_MusicVolume", self.db.profile.musicVolume / 100)
        end
        if self.db.profile.enableRandomMusic then
            bgm = LSM:Fetch("sound", self:getRandomMusic(), noDefault)
        else
            bgm = LSM:Fetch("sound", self.db.profile.music, noDefault)
        end
        PlayMusic(bgm)
    end
    if self.db.profile.enableCountdownFinalSound then
        local cdm = LSM:Fetch("sound", self.db.profile.countdownFinalSound, noDefault)
        PlaySoundFile(cdm, "SFX")
    end
end

function DragonSpeedway:handleDragonRaceCountdown()
    if self.db.profile.enableCameraDistance then
        self.db.char.globalCameraDistance = GetCameraZoom()
        self:setCameraDistance(self.db.profile.cameraDistance)
    end
end

function DragonSpeedway:handleDragonRaceEnd()
    if self.db.profile.enableVictorySound then
        local victory = LSM:Fetch("sound", self.db.profile.victorySound, noDefault)
        PlaySoundFile(victory, "SFX")
    end
    StopMusic()
    if self.db.profile.forceMusicSetting then
        C_CVar.SetCVar("Sound_EnableMusic", globalMusicEnable)
    end
    if self.db.profile.enableMusicVolume then
        C_CVar.SetCVar("Sound_MusicVolume", globalMusicVolume)
    end
    if self.db.profile.enableCameraDistance then
        self:setCameraDistance(self.db.char.globalCameraDistance)
    end
    if self.db.profile.defMusicRacesSetting then
        -- default dragonriding music
        -- sound/music/dragonflight/mus_100_dragonrace_h.mp3
        PlayMusic(4887933)
    end
end

function DragonSpeedway:handleDragonRaceRestart()
    StopMusic()
end

function DragonSpeedway:handleDragonridingMount()
    -- only apply camera on fresh mount, not relog
    if self.db.profile.enableMountCameraDistance
    and not self.db.profile.enableCameraDistance then
        if not self.db.char.isMountedWithGlide then
            self.db.char.globalCameraDistance = GetCameraZoom()
            self:setCameraDistance(self.db.profile.cameraDistance)
            self.db.char.isMountedWithGlide = true
        end
        -- if flag already true, this is relog - don't touch camera
    end

    if self.db.profile.defMusicRacesSetting then
        -- default dragonriding music
        -- sound/music/dragonflight/mus_100_dragonrace_h.mp3
        PlayMusic(4887933)
    end
end

function DragonSpeedway:handleDragonridingDismount()
    if self.db.char.isMountedWithGlide then
        if self.db.profile.enableMountCameraDistance
        and not self.db.profile.enableCameraDistance then
            self:setCameraDistance(self.db.char.globalCameraDistance)
        end
        self.db.char.isMountedWithGlide = false
    end

    StopMusic()
end

function DragonSpeedway:reconcileMountState()
    if IsMounted() then
        -- don't touch camera or state
        return
    end

    if self.db.char.isMountedWithGlide then
        -- was mounted with camera applied but now dismounted
        self:handleDragonridingDismount()
    end
    -- not mounted and flag not set - nothing to do
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

        -- initialize AceDB (no third param = character-specific profiles by default)
        self.db = LibStub("AceDB-3.0"):New("DragonSpeedwayDB", defaults)

        -- build hashtable of sounds
        self.hashtable = LSM:HashTable("sound")

        -- set dynamic sound defaults (needs LSM loaded first)
        self:setDynamicDefaults()

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

function DragonSpeedway:PLAYER_CAN_GLIDE_CHANGED(event, canGlide)
    if canGlide then
        -- on a dynamic-flight mount in a dynamic-flight zone
        -- IsMounted() may still be false due to event timing
        self:handleDragonridingMount()
    elseif not canGlide and self.db.char.isMountedWithGlide and not IsMounted() then
        -- actually dismounted (not just zone transition to no-fly area)
        self:handleDragonridingDismount()
    end
    -- if canGlide changed but still mounted, do nothing (zone transition)
end

function DragonSpeedway:PLAYER_MOUNT_DISPLAY_CHANGED(event)
    -- fallback - catches dismount when canGlide was already false
    -- (ie. dismounting in a no-fly zone)
    if self.db.char.isMountedWithGlide and not IsMounted() then
        self:handleDragonridingDismount()
    end
end

-- loading into places while mounted can confuse aura events
-- happens also when leaving instances into a mounted state
-- workaround by manually checking for mount status on each loading screen
-- this also takes care of login issue with losing spell instance IDs
function DragonSpeedway:LOADING_SCREEN_DISABLED(event, ...)
    -- schedule in 2sec to make sure it grabs the ID
    addonVars.SchedulerLib:ScheduleUniqueTask(2, self.reconcileMountState, self)
end

--------------------------------------------------------------------------------
-- register events and listen
--------------------------------------------------------------------------------

DragonSpeedway:RegisterEvent("ADDON_LOADED")
DragonSpeedway:RegisterEvent("UNIT_AURA")
DragonSpeedway:RegisterEvent("LOADING_SCREEN_DISABLED")
DragonSpeedway:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
DragonSpeedway:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")


DragonSpeedway:SetScript("OnEvent", DragonSpeedway.OnEvent)
