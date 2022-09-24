-- global local vars

local addonName, addonVars = ...


-- libraries

local LSM = LibStub("LibSharedMedia-3.0")


-- local lists and vars

local spyroOne = "Spyro Reignited Trilogy 1"
local spyroTwo = "Spyro Reignited Trilogy 2"
local spyroThree = "Spyro Reignited Trilogy 3"


-- functions

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
    end

    CloseDropDownMenus()
end

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
            --print(key, value) -- debug
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

local function countdownDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        --print(key, value) -- debug
        info.text = value
        info.arg1, info.arg2, info.checked = 'countdown', value, value == DragonSpeedway.db.countdownSound
        UIDropDownMenu_AddButton(info, level)
    end
end

local function countdownFinalDropDownInit(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    -- list all sounds
    info.func = setValue
    for key, value in ipairs(addonVars.sounds) do
        --print(key, value) -- debug
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
        --print(key, value) -- debug
        info.text = value
        info.arg1, info.arg2, info.checked = 'victory', value, value == DragonSpeedway.db.victorySound
        UIDropDownMenu_AddButton(info, level)
    end
end

 
-- initialize options

function DragonSpeedway:InitializeOptions()
    self.panel = CreateFrame("Frame")
    self.panel.name = "DragonSpeedway"
    
    self.category = Settings.RegisterCanvasLayoutCategory(self.panel, self.panel.name)
    
    -- scrolling for the options window
    -- blizz broke the ui so I cant do this yet lmao

    local title = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    title:SetText("DragonSpeedway")
    
    -- countdown sound
    local countdownTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    countdownTitle:SetPoint("TOPLEFT", title, 0, -35)
    countdownTitle:SetText("[Not Yet Implemented] Countdown sound:")
    
    local countdownDropDown = CreateFrame("Frame", "countdownDropDown", self.panel, "UIDropDownMenuTemplate")
    countdownDropDown:SetPoint("TOPLEFT", countdownTitle, -20, -20)
    UIDropDownMenu_SetWidth(countdownDropDown, 200)
    UIDropDownMenu_SetText(countdownDropDown, self.db.countdownSound)
    
    UIDropDownMenu_Initialize(countdownDropDown, countdownDropDownInit, _, 1)
    
    -- countdown final sound
    local countdownFinalTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    countdownFinalTitle:SetPoint("TOPLEFT", countdownTitle, 0, -60)
    countdownFinalTitle:SetText("Race started sound:")
    
    local countdownFinalDropDown = CreateFrame("Frame", "countdownFinalDropDown", self.panel, "UIDropDownMenuTemplate")
    countdownFinalDropDown:SetPoint("TOPLEFT", countdownFinalTitle, -20, -20)
    UIDropDownMenu_SetWidth(countdownFinalDropDown, 200)
    UIDropDownMenu_SetText(countdownFinalDropDown, self.db.countdownFinalSound)
    
    UIDropDownMenu_Initialize(countdownFinalDropDown, countdownFinalDropDownInit, _, 1)
    
    -- countdown final sound preview button
    local countdownFinalPlayButton = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
	countdownFinalPlayButton:SetPoint("TOPRIGHT", countdownFinalDropDown, 45, -3)
	countdownFinalPlayButton:SetText("PLAY")
	countdownFinalPlayButton:SetWidth(50)
	countdownFinalPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.countdownFinalSound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)
    
    -- music
    local musicTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    musicTitle:SetPoint("TOPLEFT", countdownFinalTitle, 0, -60)
    musicTitle:SetText("BGM music:")
    
    local musicDropDown = CreateFrame("Frame", "musicDropDown", self.panel, "UIDropDownMenuTemplate")
    musicDropDown:SetPoint("TOPLEFT", musicTitle, -20, -20)
    UIDropDownMenu_SetWidth(musicDropDown, 200)
    UIDropDownMenu_SetText(musicDropDown, self.db.music)
    
    UIDropDownMenu_Initialize(musicDropDown, musicDropDownInit, _, 1)
    
    -- music preview button
    local musicPlayButton = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
	musicPlayButton:SetPoint("TOPRIGHT", musicDropDown, 45, -3)
	musicPlayButton:SetText("PLAY")
	musicPlayButton:SetWidth(50)
	musicPlayButton:SetScript("OnClick", function()
        local bgm = LSM:Fetch("sound", self.db.music, noDefault)
        PlayMusic(bgm)
	end)
    
    -- music stop button
    local musicStopButton = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
	musicStopButton:SetPoint("TOPRIGHT", musicDropDown, 100, -3)
	musicStopButton:SetText("STOP")
	musicStopButton:SetWidth(50)
	musicStopButton:SetScript("OnClick", function()
        StopMusic()
	end)
    
    -- victory sound
    local victoryTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    victoryTitle:SetPoint("TOPLEFT", musicTitle, 0, -60)
    victoryTitle:SetText("Race finished sound:")
    
    local victoryDropDown = CreateFrame("Frame", "victoryDropDown", self.panel, "UIDropDownMenuTemplate")
    victoryDropDown:SetPoint("TOPLEFT", victoryTitle, -20, -20)
    UIDropDownMenu_SetWidth(victoryDropDown, 200)
    UIDropDownMenu_SetText(victoryDropDown, self.db.victorySound)
    
    UIDropDownMenu_Initialize(victoryDropDown, victoryDropDownInit, _, 1)
    
    -- victory sound preview button
    local victoryPlayButton = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
	victoryPlayButton:SetPoint("TOPRIGHT", victoryDropDown, 45, -3)
	victoryPlayButton:SetText("PLAY")
	victoryPlayButton:SetWidth(50)
	victoryPlayButton:SetScript("OnClick", function()
        local cdm = LSM:Fetch("sound", self.db.victorySound, noDefault)
        PlaySoundFile(cdm, "SFX")
	end)
    
    -- check buttons for disabling specific sounds
    
    -- countdown sound
    local countdownButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	countdownButton:SetPoint("TOPLEFT", victoryTitle, 0, -70)
	countdownButton.Text:SetText("[Not Yet Implemented] Enable countdown sound")
	countdownButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableCountdownSound = self:GetChecked()
	end)
    -- initial button state
	countdownButton:SetChecked(self.db.enableCountdownSound)
    
    -- countdown final sound
    local countdownFinalButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	countdownFinalButton:SetPoint("TOPLEFT", countdownButton, 0, -40)
	countdownFinalButton.Text:SetText("Enable race started sound")
	countdownFinalButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableCountdownFinalSound = self:GetChecked()
	end)
    -- initial button state
	countdownFinalButton:SetChecked(self.db.enableCountdownFinalSound)
    
    -- music
    local musicButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	musicButton:SetPoint("TOPLEFT", countdownFinalButton, 0, -40)
	musicButton.Text:SetText("Enable BGM music")
	musicButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableMusic = self:GetChecked()
	end)
    -- initial button state
	musicButton:SetChecked(self.db.enableMusic)
    
    -- victory sound
    local victoryButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	victoryButton:SetPoint("TOPLEFT", musicButton, 0, -40)
	victoryButton.Text:SetText("Enable race finished sound")
	victoryButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableVictorySound = self:GetChecked()
	end)
    -- initial button state
	victoryButton:SetChecked(self.db.enableVictorySound)
    
    -- slider for volume overwrite
    
    -- volume slider title
    local volumeSliderTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    volumeSliderTitle:SetPoint("TOPLEFT", victoryButton, 0, -45)
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
	volumeButton:SetPoint("TOPRIGHT", volumeSlider, 45, 5)
    volumeButton.Text:SetText("Enable music volume overwrite")
	volumeButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.enableMusicVolume = self:GetChecked()
	end)
    -- initial button state
	volumeButton:SetChecked(self.db.enableMusicVolume)
    
    -- force turn music ON button
    local forceMusicButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	forceMusicButton:SetPoint("TOPLEFT", volumeSlider, 0, -40)
    forceMusicButton.Text:SetText("Enable music if disabled")
	forceMusicButton:SetScript("OnClick", function(self)
		DragonSpeedway.db.forceMusicSetting = self:GetChecked()
	end)
    -- initial button state
	forceMusicButton:SetChecked(self.db.forceMusicSetting)
    
    
    Settings.RegisterAddOnCategory(self.category)
end
