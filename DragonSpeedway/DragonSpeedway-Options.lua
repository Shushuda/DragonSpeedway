--------------------------------------------------------------------------------
-- global local vars
--------------------------------------------------------------------------------

local addonName, addonVars = ...

--------------------------------------------------------------------------------
-- libraries
--------------------------------------------------------------------------------

local LSM = LibStub("LibSharedMedia-3.0")

--------------------------------------------------------------------------------
-- local lists and vars
--------------------------------------------------------------------------------

local spyroOne = "Spyro Reignited Trilogy 1"
local spyroTwo = "Spyro Reignited Trilogy 2"
local spyroThree = "Spyro Reignited Trilogy 3"

--------------------------------------------------------------------------------
-- local functions
--------------------------------------------------------------------------------

-- OnClick function for picking an option
local function setValue(self, soundType, newValue, checked)
    if soundType == 'music' then
        DragonSpeedway.db.music = newValue
        UIDropDownMenu_SetText(musicDropDown, DragonSpeedway.db.music)
    elseif soundType == 'countdown' then
        DragonSpeedway.db.countdownSound = newValue
        UIDropDownMenu_SetText(countdownDropDown, DragonSpeedway.db.countdownSound)
    elseif soundType == 'countdown_final' then
        DragonSpeedway.db.countdownFinalSound = newValue
        UIDropDownMenu_SetText(countdownFinalDropDown, DragonSpeedway.db.countdownFinalSound)
    elseif soundType == 'victory' then
        DragonSpeedway.db.victorySound = newValue
        UIDropDownMenu_SetText(victoryDropDown, DragonSpeedway.db.victorySound)
    elseif soundType == 'random' then
        DragonSpeedway.db.randomMusic = newValue
        UIDropDownMenu_SetText(randomDropDown, DragonSpeedway.db.randomMusic)
    elseif soundType == 'skyward_ascent' then
        DragonSpeedway.db.skywardAscentSound = newValue
        UIDropDownMenu_SetText(skywardAscentDropDown, DragonSpeedway.db.skywardAscentSound)
    elseif soundType == 'surge_forward' then
        DragonSpeedway.db.surgeForwardSound = newValue
        UIDropDownMenu_SetText(surgeForwardDropDown, DragonSpeedway.db.surgeForwardSound)
    elseif soundType == 'whirling_surge' then
        DragonSpeedway.db.whirlingSurgeSound = newValue
        UIDropDownMenu_SetText(whirlingSurgeDropDown, DragonSpeedway.db.whirlingSurgeSound)
    elseif soundType == 'bronze_rewind' then
        DragonSpeedway.db.bronzeRewindSound = newValue
        UIDropDownMenu_SetText(bronzeRewindDropDown, DragonSpeedway.db.bronzeRewindSound)
    end

    CloseDropDownMenus()
end

--------------------------------------------------------------------------------
-- music / sound drop down inits
--------------------------------------------------------------------------------

local function musicDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    if (level or 1) == 1 then
        -- Display game groups
        info.text, info.menuList, info.hasArrow = spyroOne, 'Spyro1', true
        UIDropDownMenu_AddButton(info)
        info.text, info.menuList, info.hasArrow = spyroTwo, 'Spyro2', true
        UIDropDownMenu_AddButton(info)
        info.text, info.menuList, info.hasArrow = spyroThree, 'Spyro3', true
        UIDropDownMenu_AddButton(info)
        info.text, info.menuList, info.hasArrow = "Custom", 'custom', true
        UIDropDownMenu_AddButton(info)

    elseif menuList == 'Spyro1' then
        -- list Spyro 1 music
        info.func = setValue
        for key, value in ipairs(addonVars.spyroOneTable) do
            info.text = value
            info.arg1, info.arg2, info.checked = 'music', value, value == DragonSpeedway.db.music
            UIDropDownMenu_AddButton(info, level)
        end
    elseif menuList == 'Spyro2' then
        -- list Spyro 2 music
        info.func = setValue
        for key, value in ipairs(addonVars.spyroTwoTable) do
            info.text = value
            info.arg1, info.arg2, info.checked = 'music', value, value == DragonSpeedway.db.music
            UIDropDownMenu_AddButton(info, level)
        end
    elseif menuList == 'Spyro3' then
        -- list Spyro 3 music
        info.func = setValue
        for key, value in ipairs(addonVars.spyroThreeTable) do
            info.text = value
            info.arg1, info.arg2, info.checked = 'music', value, value == DragonSpeedway.db.music
            UIDropDownMenu_AddButton(info, level)
        end
    elseif menuList == 'custom' then
        -- list custom music
        info.func = setValue
        for key, value in ipairs(addonVars.custom) do
            info.text = value
            info.arg1, info.arg2, info.checked = 'music', value, value == DragonSpeedway.db.music
            UIDropDownMenu_AddButton(info, level)
        end
    end
end

local function countdownFinalDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'countdown_final', value, value == DragonSpeedway.db.countdownFinalSound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function victoryDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'victory', value, value == DragonSpeedway.db.victorySound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function randomDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all groups
    info.func = setValue
    for key, value in ipairs(addonVars.randomGroupsKeys) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'random', value, value == DragonSpeedway.db.randomMusic
        UIDropDownMenu_AddButton(info, level)
    end
end

--------------------------------------------------------------------------------
-- spell dropdown inits
--------------------------------------------------------------------------------

local function skywardAscentDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'skyward_ascent', value, value == DragonSpeedway.db.skywardAscentSound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function surgeForwardDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'surge_forward', value, value == DragonSpeedway.db.surgeForwardSound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function whirlingSurgeDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'whirling_surge', value, value == DragonSpeedway.db.whirlingSurgeSound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function bronzeRewindDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        info.text = value
        info.arg1, info.arg2, info.checked = 'bronze_rewind', value, value == DragonSpeedway.db.bronzeRewindSound
        UIDropDownMenu_AddButton(info, level)
    end
end

--------------------------------------------------------------------------------
-- initialize options
--------------------------------------------------------------------------------

-- main panel
function DragonSpeedway:InitializeMainPanel()
    self.panel = CreateFrame("Frame")
    self.panel.name = "DragonSpeedway"

    self.category = Settings.RegisterCanvasLayoutCategory(self.panel, self.panel.name)

    local title = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    title:SetText("DragonSpeedway")

    local desc = self.panel:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
    desc:SetPoint("TOPLEFT", title, 1, -30)
    desc:SetText("Lorem impsum sadnjsajkd ahjsd bhjas ahjsdbasbhjb saahjbdhj asbhjbhj")

    --------------------------------
    -- randomizer header
    --------------------------------
    local randomizerLine = self.panel:CreateLine()
    randomizerLine:SetStartPoint("TOPLEFT", self.panel, 10, -100)
    randomizerLine:SetEndPoint("TOPRIGHT", self.panel, -20, -100)
    randomizerLine:SetColorTexture(1,1,1,0.25)
    randomizerLine:SetThickness(2)

    local randomizerHeader = self.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    randomizerHeader:SetPoint("TOPLEFT", randomizerLine, 5, 13)
    randomizerHeader:SetText("Shuffle")

    --------------------------------
    -- music randomizer
    --------------------------------
    local randomTitle = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    randomTitle:SetPoint("TOPLEFT", randomizerLine, 10, -15)
    randomTitle:SetText("Randomize music:")

    local randomDropDown = CreateFrame("Frame", "randomDropDown", self.panel, "UIDropDownMenuTemplate")
    randomDropDown:SetPoint("TOPLEFT", randomTitle, -20, -20)
    UIDropDownMenu_SetWidth(randomDropDown, 200)
    UIDropDownMenu_SetText(randomDropDown, self.db.randomMusic)

    UIDropDownMenu_Initialize(randomDropDown, randomDropDownInit, _, 1)

    -- randomizer ON OFF button
    local randomButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	randomButton:SetPoint("TOPRIGHT", randomDropDown, 200, -1)
    randomButton.Text:SetText("Enable music randomizer")
	randomButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableRandomMusic = self:GetChecked()
	end)
    -- initial button state
	randomButton:SetChecked(self.db.enableRandomMusic)

    --------------------------------
    -- volume overwrite header
    --------------------------------
    local volumeLine = self.panel:CreateLine()
    volumeLine:SetStartPoint("TOPLEFT", self.panel, 10, -206)
    volumeLine:SetEndPoint("TOPRIGHT", self.panel, -20, -206)
    volumeLine:SetColorTexture(1,1,1,0.25)
    volumeLine:SetThickness(2)

    local volumeHeader = self.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    volumeHeader:SetPoint("TOPLEFT", volumeLine, 5, 13)
    volumeHeader:SetText("Spell sounds")

    --------------------------------
    -- volume overwrite slider
    --------------------------------

    -- volume slider title
    local volumeSliderTitle = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    volumeSliderTitle:SetPoint("TOPLEFT", volumeLine, 10, -15)
    volumeSliderTitle:SetText("Music volume overwrite")

    -- volume slider
    local volumeSlider = CreateFrame("Slider", "DragonSpeedwayVolumeSlider", self.panel, "OptionsSliderTemplate")
    volumeSlider:SetPoint("TOPLEFT", volumeSliderTitle, 0, -35)
    volumeSlider:SetOrientation('HORIZONTAL')
    volumeSlider:SetWidth(200)
    -- stepping
    volumeSlider:SetMinMaxValues(0, 100)
    volumeSlider:SetValueStep(1)
    volumeSlider:SetObeyStepOnDrag(true)
    volumeSlider:SetStepsPerPage(5)
    _G[volumeSlider:GetName().."Low"]:SetText("0%")
	_G[volumeSlider:GetName().."High"]:SetText("100%")
    -- initial value
    volumeSlider:SetValue(self.db.musicVolume)
    volumeSlider.Text:SetText(self.db.musicVolume)
    -- action
    volumeSlider:SetScript("OnValueChanged", function(self, value, userInput)
        DragonSpeedway.db.musicVolume = value
        volumeSlider.Text:SetText(value)
	end)
    -- render slider
    volumeSlider:Enable()
    volumeSlider:Show()

    -- volume ON OFF button
    local volumeButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	volumeButton:SetPoint("TOPRIGHT", volumeSlider, 200, 5)
    volumeButton.Text:SetText("Enable music volume overwrite")
	volumeButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableMusicVolume = self:GetChecked()
	end)
    -- initial button state
	volumeButton:SetChecked(self.db.enableMusicVolume)

    --------------------------------
    -- force enable music button
    --------------------------------
    local forceMusicButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	forceMusicButton:SetPoint("TOPLEFT", volumeLine, 10, -94)
    forceMusicButton.Text:SetText("Enable music if disabled")
	forceMusicButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.forceMusicSetting = self:GetChecked()
	end)
    -- initial button state
	forceMusicButton:SetChecked(self.db.forceMusicSetting)

    --------------------------------
    -- race settings header
    --------------------------------
    local settingsLine = self.panel:CreateLine()
    settingsLine:SetStartPoint("TOPLEFT", self.panel, 10, -364)
    settingsLine:SetEndPoint("TOPRIGHT", self.panel, -20, -364)
    settingsLine:SetColorTexture(1,1,1,0.25)
    settingsLine:SetThickness(2)

    local settingsHeader = self.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    settingsHeader:SetPoint("TOPLEFT", settingsLine, 5, 13)
    settingsHeader:SetText("Race settings")

    --------------------------------
    -- play BGM music only during races button
    --------------------------------
    local musicRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	musicRacesButton:SetPoint("TOPLEFT", settingsLine, 10, -15)
    musicRacesButton.Text:SetText("Play BGM music only during races")
	musicRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.musicRacesSetting = self:GetChecked()
	end)
    -- initial button state
	musicRacesButton:SetChecked(self.db.musicRacesSetting)

    --------------------------------
    -- play spell sounds only during races button
    --------------------------------
    local spellRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	spellRacesButton:SetPoint("TOPLEFT", musicRacesButton, 0, -40)
    spellRacesButton.Text:SetText("Play spell sounds only during races")
	spellRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.spellRacesSetting = self:GetChecked()
	end)
    -- initial button state
	spellRacesButton:SetChecked(self.db.spellRacesSetting)

    --------------------------------
    -- overwrite music volume only during races button
    --------------------------------
    local volumeRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	volumeRacesButton:SetPoint("TOPLEFT", spellRacesButton, 0, -40)
    volumeRacesButton.Text:SetText("Overwrite music volume only during races")
	volumeRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.volumeRacesSetting = self:GetChecked()
	end)
    -- initial button state
	volumeRacesButton:SetChecked(self.db.volumeRacesSetting)

    --------------------------------
    -- force enable music only during races button
    --------------------------------
    local forceMusicRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	forceMusicRacesButton:SetPoint("TOPLEFT", volumeRacesButton, 0, -40)
    forceMusicRacesButton.Text:SetText("Enable music if disabled only during races")
	forceMusicRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.forceMusicRacesSetting = self:GetChecked()
	end)
    -- initial button state
	forceMusicRacesButton:SetChecked(self.db.forceMusicRacesSetting)

    --------------------------------
    -- overwrite camera distance only during races button
    --------------------------------
    local cameraRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cameraRacesButton:SetPoint("TOPLEFT", forceMusicRacesButton, 0, -40)
    cameraRacesButton.Text:SetText("Overwrite camera distance only during races")
	cameraRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.cameraRacesSetting = self:GetChecked()
	end)
    -- initial button state
	cameraRacesButton:SetChecked(self.db.cameraRacesSetting)


    Settings.RegisterAddOnCategory(self.category)
end

-- sub-panel Music and Sounds
function DragonSpeedway:InitializeMusicPanel()
    local panelMusic = CreateFrame("Frame")
    panelMusic.name = "Music and Sounds"

    local category_music = Settings.RegisterCanvasLayoutSubcategory(self.category, panelMusic, panelMusic.name)

    local title = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    title:SetText("Music and Sounds")

    local desc = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
    desc:SetPoint("TOPLEFT", title, 1, -30)
    desc:SetText("Lorem impsum sadnjsajkd ahjsd bhjas ahjsdbasbhjb saahjbdhj asbhjbhj")

    --------------------------------
    -- music and sounds header
    --------------------------------
    local musicLine = panelMusic:CreateLine()
    musicLine:SetStartPoint("TOPLEFT", panelMusic, 10, -100)
    musicLine:SetEndPoint("TOPRIGHT", panelMusic, -20, -100)
    musicLine:SetColorTexture(1,1,1,0.25)
    musicLine:SetThickness(2)

    local musicHeader = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    musicHeader:SetPoint("TOPLEFT", musicLine, 5, 13)
    musicHeader:SetText("Music and Sounds")

    --------------------------------
    -- countdown final sound
    --------------------------------
    local countdownFinalTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    countdownFinalTitle:SetPoint("TOPLEFT", musicLine, 10, -15)
    countdownFinalTitle:SetText("Race started sound:")

    local countdownFinalDropDown = CreateFrame("Frame", "countdownFinalDropDown", panelMusic, "UIDropDownMenuTemplate")
    countdownFinalDropDown:SetPoint("TOPLEFT", countdownFinalTitle, -20, -20)
    UIDropDownMenu_SetWidth(countdownFinalDropDown, 200)
    UIDropDownMenu_SetText(countdownFinalDropDown, self.db.countdownFinalSound)

    UIDropDownMenu_Initialize(countdownFinalDropDown, countdownFinalDropDownInit, _, 1)

    -- countdown final sound preview button
    local countdownFinalPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	countdownFinalPlayButton:SetPoint("TOPRIGHT", countdownFinalDropDown, 45, -3)
	countdownFinalPlayButton:SetText("PLAY")
	countdownFinalPlayButton:SetWidth(50)
	countdownFinalPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.countdownFinalSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- countdown final sound enable button
    local countdownFinalButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
    countdownFinalButton:SetPoint("TOPRIGHT", countdownFinalDropDown, 200, -1)
	countdownFinalButton.Text:SetText("Enable race started sound")
	countdownFinalButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableCountdownFinalSound = self:GetChecked()
	end)
    -- initial button state
	countdownFinalButton:SetChecked(self.db.enableCountdownFinalSound)

    --------------------------------
    -- music
    --------------------------------
    local musicTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    musicTitle:SetPoint("TOPLEFT", countdownFinalTitle, 0, -60)
    musicTitle:SetText("BGM music:")

    local musicDropDown = CreateFrame("Frame", "musicDropDown", panelMusic, "UIDropDownMenuTemplate")
    musicDropDown:SetPoint("TOPLEFT", musicTitle, -20, -20)
    UIDropDownMenu_SetWidth(musicDropDown, 200)
    UIDropDownMenu_SetText(musicDropDown, self.db.music)

    UIDropDownMenu_Initialize(musicDropDown, musicDropDownInit, _, 1)

    -- music preview button
    local musicPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	musicPlayButton:SetPoint("TOPRIGHT", musicDropDown, 45, -3)
	musicPlayButton:SetText("PLAY")
	musicPlayButton:SetWidth(50)
	musicPlayButton:SetScript("OnClick", function()
        local bgm = LSM:Fetch("sound", self.db.music, noDefault)
        PlayMusic(bgm)
	end)

    -- music stop button
    local musicStopButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	musicStopButton:SetPoint("TOPRIGHT", musicDropDown, 100, -3)
	musicStopButton:SetText("STOP")
	musicStopButton:SetWidth(50)
	musicStopButton:SetScript("OnClick", function()
        StopMusic()
	end)

    -- music enable button
    local musicButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	musicButton:SetPoint("TOPRIGHT", musicDropDown, 200, -1)
	musicButton.Text:SetText("Enable BGM music")
	musicButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableMusic = self:GetChecked()
	end)
    -- initial button state
	musicButton:SetChecked(self.db.enableMusic)

    --------------------------------
    -- victory sound
    --------------------------------
    local victoryTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    victoryTitle:SetPoint("TOPLEFT", musicTitle, 0, -60)
    victoryTitle:SetText("Race finished sound:")

    local victoryDropDown = CreateFrame("Frame", "victoryDropDown", panelMusic, "UIDropDownMenuTemplate")
    victoryDropDown:SetPoint("TOPLEFT", victoryTitle, -20, -20)
    UIDropDownMenu_SetWidth(victoryDropDown, 200)
    UIDropDownMenu_SetText(victoryDropDown, self.db.victorySound)

    UIDropDownMenu_Initialize(victoryDropDown, victoryDropDownInit, _, 1)

    -- victory sound preview button
    local victoryPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	victoryPlayButton:SetPoint("TOPRIGHT", victoryDropDown, 45, -3)
	victoryPlayButton:SetText("PLAY")
	victoryPlayButton:SetWidth(50)
	victoryPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.victorySound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- victory sound enable button
    local victoryButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	victoryButton:SetPoint("TOPRIGHT", victoryDropDown, 200, -1)
	victoryButton.Text:SetText("Enable race finished sound")
	victoryButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableVictorySound = self:GetChecked()
	end)
    -- initial button state
	victoryButton:SetChecked(self.db.enableVictorySound)

    --------------------------------
    -- spell sounds header
    --------------------------------
    local spellLine = panelMusic:CreateLine()
    spellLine:SetStartPoint("TOPLEFT", panelMusic, 10, -320)
    spellLine:SetEndPoint("TOPRIGHT", panelMusic, -20, -320)
    spellLine:SetColorTexture(1,1,1,0.25)
    spellLine:SetThickness(2)

    local spellHeader = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    spellHeader:SetPoint("TOPLEFT", spellLine, 5, 13)
    spellHeader:SetText("Spell sounds")

    --------------------------------
    -- Skyward Ascent sound
    --------------------------------
    local skywardAscentTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    skywardAscentTitle:SetPoint("TOPLEFT", spellLine, 10, -15)
    skywardAscentTitle:SetText("Skyward Ascent sound:")

    local skywardAscentDropDown = CreateFrame("Frame", "skywardAscentDropDown", panelMusic, "UIDropDownMenuTemplate")
    skywardAscentDropDown:SetPoint("TOPLEFT", skywardAscentTitle, -20, -20)
    UIDropDownMenu_SetWidth(skywardAscentDropDown, 200)
    UIDropDownMenu_SetText(skywardAscentDropDown, self.db.skywardAscentSound)

    UIDropDownMenu_Initialize(skywardAscentDropDown, skywardAscentDropDownInit, _, 1)

    -- Skyward Ascent sound preview button
    local skywardAscentPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	skywardAscentPlayButton:SetPoint("TOPRIGHT", skywardAscentDropDown, 45, -3)
	skywardAscentPlayButton:SetText("PLAY")
	skywardAscentPlayButton:SetWidth(50)
	skywardAscentPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.skywardAscentSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- Skyward Ascent sound enable button
    local skywardAscentButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	skywardAscentButton:SetPoint("TOPRIGHT", skywardAscentDropDown, 200, -1)
	skywardAscentButton.Text:SetText("Enable Skyward Ascent sound")
	skywardAscentButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableSkywardAscentSound = self:GetChecked()
	end)
    -- initial button state
	skywardAscentButton:SetChecked(self.db.enableSkywardAscentSound)

    --------------------------------
    -- Surge Forward sound
    --------------------------------
    local surgeForwardTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    surgeForwardTitle:SetPoint("TOPLEFT", skywardAscentTitle, 0, -60)
    surgeForwardTitle:SetText("Surge Forward sound:")

    local surgeForwardDropDown = CreateFrame("Frame", "surgeForwardDropDown", panelMusic, "UIDropDownMenuTemplate")
    surgeForwardDropDown:SetPoint("TOPLEFT", surgeForwardTitle, -20, -20)
    UIDropDownMenu_SetWidth(surgeForwardDropDown, 200)
    UIDropDownMenu_SetText(surgeForwardDropDown, self.db.surgeForwardSound)

    UIDropDownMenu_Initialize(surgeForwardDropDown, surgeForwardDropDownInit, _, 1)

    -- Surge Forward sound preview button
    local surgeForwardPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	surgeForwardPlayButton:SetPoint("TOPRIGHT", surgeForwardDropDown, 45, -3)
	surgeForwardPlayButton:SetText("PLAY")
	surgeForwardPlayButton:SetWidth(50)
	surgeForwardPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.surgeForwardSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- Surge Forward sound enable button
    local surgeForwardButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	surgeForwardButton:SetPoint("TOPRIGHT", surgeForwardDropDown, 200, -1)
	surgeForwardButton.Text:SetText("Enable Surge Forward sound")
	surgeForwardButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableSurgeForwardSound = self:GetChecked()
	end)
    -- initial button state
	surgeForwardButton:SetChecked(self.db.enableSurgeForwardSound)

    --------------------------------
    -- Whirling Surge sound
    --------------------------------
    local whirlingSurgeTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    whirlingSurgeTitle:SetPoint("TOPLEFT", surgeForwardTitle, 0, -60)
    whirlingSurgeTitle:SetText("Whirling Surge sound:")

    local whirlingSurgeDropDown = CreateFrame("Frame", "whirlingSurgeDropDown", panelMusic, "UIDropDownMenuTemplate")
    whirlingSurgeDropDown:SetPoint("TOPLEFT", whirlingSurgeTitle, -20, -20)
    UIDropDownMenu_SetWidth(whirlingSurgeDropDown, 200)
    UIDropDownMenu_SetText(whirlingSurgeDropDown, self.db.whirlingSurgeSound)

    UIDropDownMenu_Initialize(whirlingSurgeDropDown, whirlingSurgeDropDownInit, _, 1)

    -- Whirling Surge sound preview button
    local whirlingSurgePlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	whirlingSurgePlayButton:SetPoint("TOPRIGHT", whirlingSurgeDropDown, 45, -3)
	whirlingSurgePlayButton:SetText("PLAY")
	whirlingSurgePlayButton:SetWidth(50)
	whirlingSurgePlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.whirlingSurgeSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- Whirling Surge sound enable button
    local whirlingSurgeButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	whirlingSurgeButton:SetPoint("TOPRIGHT", whirlingSurgeDropDown, 200, -1)
	whirlingSurgeButton.Text:SetText("Enable Whirling Surge sound")
	whirlingSurgeButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableWhirlingSurgeSound = self:GetChecked()
	end)
    -- initial button state
	whirlingSurgeButton:SetChecked(self.db.enableWhirlingSurgeSound)

    --------------------------------
    -- Bronze Rewind sound
    --------------------------------
    local bronzeRewindTitle = panelMusic:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    bronzeRewindTitle:SetPoint("TOPLEFT", whirlingSurgeTitle, 0, -60)
    bronzeRewindTitle:SetText("Bronze Rewind sound:")

    local bronzeRewindDropDown = CreateFrame("Frame", "bronzeRewindDropDown", panelMusic, "UIDropDownMenuTemplate")
    bronzeRewindDropDown:SetPoint("TOPLEFT", bronzeRewindTitle, -20, -20)
    UIDropDownMenu_SetWidth(bronzeRewindDropDown, 200)
    UIDropDownMenu_SetText(bronzeRewindDropDown, self.db.bronzeRewindSound)

    UIDropDownMenu_Initialize(bronzeRewindDropDown, bronzeRewindDropDownInit, _, 1)

    -- Bronze Rewind sound preview button
    local bronzeRewindPlayButton = CreateFrame("Button", nil, panelMusic, "UIPanelButtonTemplate")
	bronzeRewindPlayButton:SetPoint("TOPRIGHT", bronzeRewindDropDown, 45, -3)
	bronzeRewindPlayButton:SetText("PLAY")
	bronzeRewindPlayButton:SetWidth(50)
	bronzeRewindPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.bronzeRewindSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)

    -- Bronze Rewind sound enable button
    local bronzeRewindButton = CreateFrame("CheckButton", nil, panelMusic, "InterfaceOptionsCheckButtonTemplate")
	bronzeRewindButton:SetPoint("TOPRIGHT", bronzeRewindDropDown, 200, -1)
	bronzeRewindButton.Text:SetText("Enable Bronze Rewind sound")
	bronzeRewindButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableBronzeRewindSound = self:GetChecked()
	end)
    -- initial button state
	bronzeRewindButton:SetChecked(self.db.enableBronzeRewindSound)


    Settings.RegisterAddOnCategory(category_music)
end

-- sub-panel camera
function DragonSpeedway:InitializeCameraPanel()
    local panelCamera = CreateFrame("Frame")
    panelCamera.name = "Camera"

    local category_camera = Settings.RegisterCanvasLayoutSubcategory(self.category, panelCamera, panelCamera.name)

    local title = panelCamera:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    title:SetText("Camera settings")

    local desc = panelCamera:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
    desc:SetPoint("TOPLEFT", title, 1, -30)
    desc:SetText("Lorem impsum sadnjsajkd ahjsd bhjas ahjsdbasbhjb saahjbdhj asbhjbhj")

    --------------------------------
    -- camera header
    --------------------------------
    local distanceLine = panelCamera:CreateLine()
    distanceLine:SetStartPoint("TOPLEFT", panelCamera, 10, -100)
    distanceLine:SetEndPoint("TOPRIGHT", panelCamera, -20, -100)
    distanceLine:SetColorTexture(1,1,1,0.25)
    distanceLine:SetThickness(2)

    local distanceHeader = panelCamera:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    distanceHeader:SetPoint("TOPLEFT", distanceLine, 5, 13)
    distanceHeader:SetText("Camera distance")

    --------------------------------
    -- camera distance overwrite
    --------------------------------

    -- distance slider title
    local distanceSliderTitle = panelCamera:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    distanceSliderTitle:SetPoint("TOPLEFT", distanceLine, 10, -15)
    distanceSliderTitle:SetText("Camera distance overwrite")

    -- distance slider
    local distanceSlider = CreateFrame("Slider", "DragonSpeedwayDistanceSlider", panelCamera, "OptionsSliderTemplate")
    distanceSlider:SetPoint("TOPLEFT", distanceSliderTitle, 0, -35)
    distanceSlider:SetOrientation('HORIZONTAL')
    distanceSlider:SetWidth(200)
    -- stepping
    distanceSlider:SetMinMaxValues(0, 100)
    distanceSlider:SetValueStep(1)
    distanceSlider:SetObeyStepOnDrag(true)
    distanceSlider:SetStepsPerPage(5)
    _G[distanceSlider:GetName().."Low"]:SetText("0%")
	_G[distanceSlider:GetName().."High"]:SetText("100%")
    -- initial value
    distanceSlider:SetValue(self.db.cameraDistance)
    distanceSlider.Text:SetText(self.db.cameraDistance)
    -- action
    distanceSlider:SetScript("OnValueChanged", function(self, value, userInput)
        DragonSpeedway.db.cameraDistance = value
        distanceSlider.Text:SetText(value)
	end)
    -- render slider
    distanceSlider:Enable()
    distanceSlider:Show()

    -- distance ON OFF button
    local distanceButton = CreateFrame("CheckButton", nil, panelCamera, "InterfaceOptionsCheckButtonTemplate")
	distanceButton:SetPoint("TOPRIGHT", distanceSlider, 200, 5)
    distanceButton.Text:SetText("Enable camera distance overwrite")
	distanceButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableCameraDistance = self:GetChecked()
	end)
    -- initial button state
	distanceButton:SetChecked(self.db.enableCameraDistance)


    Settings.RegisterAddOnCategory(category_camera)
end

--------------------------------------------------------------------------------
-- initialize everything
--------------------------------------------------------------------------------

function DragonSpeedway:InitializeOptions()
    self:InitializeMainPanel()
    self:InitializeMusicPanel()
    self:InitializeCameraPanel()
end
