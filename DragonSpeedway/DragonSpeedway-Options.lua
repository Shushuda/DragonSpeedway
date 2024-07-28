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

local spyroOne = "Spyro 1"
local spyroTwo = "Spyro 2"
local spyroThree = "Spyro 3"

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

    self.category = Settings.RegisterCanvasLayoutCategory(self.panel, self.panel.name, self.panel.name)
    self.category.ID = self.panel.name

    local title = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    title:SetText("DragonSpeedway")

    local desc = self.panel:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
    desc:SetPoint("TOPLEFT", title, 1, -30)
    desc:SetText("Main settings + race-specific toggles. Please report bugs on GitHub <3")

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
	randomButton:SetPoint("TOPRIGHT", randomDropDown, 170, -1)
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
    volumeHeader:SetText("Volume settings")

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
    settingsHeader:SetText("Other settings")

    --------------------------------
    -- play default dragonriding music outside of races button
    --------------------------------
    local defMusicRacesButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	defMusicRacesButton:SetPoint("TOPLEFT", settingsLine, 10, -15)
    defMusicRacesButton.Text:SetText("Play default Dragonriding music outside of races")
	defMusicRacesButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.defMusicRacesSetting = self:GetChecked()
	end)
    -- initial button state
	defMusicRacesButton:SetChecked(self.db.defMusicRacesSetting)


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
    desc:SetText("Music and race-specific sound settings. If empty menus - check your files!")

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
    desc:SetText("Camera settings.")

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
    distanceSliderTitle:SetText("Camera distance overwrite (in yards)")

    -- distance slider
    local distanceSlider = CreateFrame("Slider", "DragonSpeedwayDistanceSlider", panelCamera, "OptionsSliderTemplate")
    distanceSlider:SetPoint("TOPLEFT", distanceSliderTitle, 0, -35)
    distanceSlider:SetOrientation('HORIZONTAL')
    distanceSlider:SetWidth(200)
    -- stepping
    distanceSlider:SetMinMaxValues(0, 28.5)
    distanceSlider:SetValueStep(0.5)
    distanceSlider:SetObeyStepOnDrag(true)
    distanceSlider:SetStepsPerPage(5)
    _G[distanceSlider:GetName().."Low"]:SetText("0")
	_G[distanceSlider:GetName().."High"]:SetText("28.5")
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

    -- mount distance ON OFF button
    local distanceMountButton = CreateFrame("CheckButton", nil, panelCamera, "InterfaceOptionsCheckButtonTemplate")
    distanceMountButton:SetPoint("TOPRIGHT", distanceSlider, 200, 5)
    distanceMountButton.Text:SetText("Enable camera distance overwrite")
    distanceMountButton:SetScript("OnClick", function(self)
        DragonSpeedway.db.enableMountCameraDistance = self:GetChecked()
    end)
    -- initial button state
    distanceMountButton:SetChecked(self.db.enableMountCameraDistance)

    -- race distance ON OFF button
    local distanceButton = CreateFrame("CheckButton", nil, panelCamera, "InterfaceOptionsCheckButtonTemplate")
	distanceButton:SetPoint("TOPRIGHT", distanceMountButton, 30, -30)
    distanceButton.Text:SetText("Only in races")
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
