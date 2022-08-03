-- global local vars

local addonName, addonVars = ...

DragonSpeedway.defaults = {
    music = addonVars.defaultBGM,
    countdownSound = addonVars.defaultCDM,
    countdownFinalSound = addonVars.defaultFinalCDM,
    victorySound = addonVars.defaultVictoryM,
    enableMusic = true,
    enableCountdownSound = true,
    enableCountdownFinalSound = true,
    enableVictorySound = true,
}


-- local lists and vars

local spyroOne = "Spyro Reignited Trilogy 1"
local spyroTwo = "Spyro Reignited Trilogy 2"
local spyroThree = "Spyro Reignited Trilogy 3"


-- functions

-- OnCLick function for picking an option
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
    
    -- music
    local musicTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    musicTitle:SetPoint("TOPLEFT", countdownFinalTitle, 0, -60)
    musicTitle:SetText("BGM music:")
    
    local musicDropDown = CreateFrame("Frame", "musicDropDown", self.panel, "UIDropDownMenuTemplate")
    musicDropDown:SetPoint("TOPLEFT", musicTitle, -20, -20)
    UIDropDownMenu_SetWidth(musicDropDown, 200)
    UIDropDownMenu_SetText(musicDropDown, self.db.music)
    
    UIDropDownMenu_Initialize(musicDropDown, musicDropDownInit, _, 1)
    
    -- victory sound
    local victoryTitle = self.panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    victoryTitle:SetPoint("TOPLEFT", musicTitle, 0, -60)
    victoryTitle:SetText("Race finished sound:")
    
    local victoryDropDown = CreateFrame("Frame", "victoryDropDown", self.panel, "UIDropDownMenuTemplate")
    victoryDropDown:SetPoint("TOPLEFT", victoryTitle, -20, -20)
    UIDropDownMenu_SetWidth(victoryDropDown, 200)
    UIDropDownMenu_SetText(victoryDropDown, self.db.victorySound)
    
    UIDropDownMenu_Initialize(victoryDropDown, victoryDropDownInit, _, 1)
    
    -- check buttons for disabling specific sounds
    
    -- countdown sound
    local countdownButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	countdownButton:SetPoint("TOPLEFT", victoryTitle, 0, -70)
	countdownButton.Text:SetText("[Not Yet Implemented] Enable countdown sound")
	countdownButton.SetValue = function(_, value)
		self.db.enableCountdownSound = (value == "1")
	end
    -- initial button state
	countdownButton:SetChecked(self.db.enableMusic)
    
    -- countdown final sound
    local countdownFinalButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	countdownFinalButton:SetPoint("TOPLEFT", countdownButton, 0, -40)
	countdownFinalButton.Text:SetText("Enable race started sound")
	countdownFinalButton.SetValue = function(_, value)
		self.db.enableCountdownFinalSound = (value == "1")
	end
	countdownFinalButton:SetChecked(self.db.enableCountdownFinalSound)
    
    -- music
    local musicButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	musicButton:SetPoint("TOPLEFT", countdownFinalButton, 0, -40)
	musicButton.Text:SetText("Enable BGM music")
	musicButton.SetValue = function(_, value)
		self.db.enableMusic = (value == "1")
	end
	musicButton:SetChecked(self.db.enableMusic)
    
    -- victory sound
    local victoryButton = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	victoryButton:SetPoint("TOPLEFT", musicButton, 0, -40)
	victoryButton.Text:SetText("Enable race finished sound")
	victoryButton.SetValue = function(_, value)
		self.db.enableVictorySound = (value == "1")
	end
	victoryButton:SetChecked(self.db.enableVictorySound)
    
    InterfaceOptions_AddCategory(DragonSpeedway.panel)
end