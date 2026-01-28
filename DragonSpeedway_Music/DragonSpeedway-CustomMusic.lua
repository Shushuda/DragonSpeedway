-- global local vars

local addonName, addonVars = ...


-- libraries

local LSM = LibStub("LibSharedMedia-3.0")


-- register music and sounds

-- HOW TO ADD CUSTOM MUSIC AND SOUNDS

-- Custom music/sounds require the usage of LibSharedMedia since 8.2
-- Each MUSIC file needs to be placed in: World of Warcraft\_retail_\Interface\Addons\DragonSpeedway_Music\Music\Custom\
-- Each SOUND file needs to be placed in: World of Warcraft\_retail_\Interface\Addons\DragonSpeedway_Music\Sounds\Custom\
-- The file path should look like this: Interface\Addons\DragonSpeedway_Music\Music\Custom\name-of-music-file.mp3
-- Use only .mp3 and .ogg files

-- The code for registering a single sound has the following structure:
-- LSM:Register("sound", <name of the music to be used ingame>, [[path-to-the-music-file]])

-- Example:
-- LSM:Register("sound", "Crystal Flight", [[Interface\Addons\DragonSpeedway_Music\Music\Custom\crystal-flight.mp3]])
-- LSM:Register("sound", "Tu tu ru tuuu", [[Interface\Addons\DragonSpeedway_Music\Sounds\Custom\fanfare-sound.mp3]])


-- Custom music

-- <place the code here


-- Custom sound effects

-- <place the code here>
