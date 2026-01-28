# DragonSpeedway
A World of Warcraft addon playing custom music and sound effects when racing using the new Dragon Riding mechanic. It works with both time trials and multiplayer races.

This addon is mostly meant to be used with Spyro Flight/Speedway music and sound effects, but it also works with custom music and sound effects - sky's the limit.

## Mandatory dependencies

This addon requires the DragonSpeedway_Music addon to work. I've separated them into two addons as a workaround for addon managers replacing the music files during update. This way you will only want to update the main DragonSpeedway addon and leave DragonSpeedway_Music outdated. You will also add music only to the DragonSpeedway_Music addon. Keep in mind that DragonSpeedway_Music will be out of date pretty fast, but it will still work fine - just load it anyway. I won't update the TOC because this will just re-trigger this update overwrite issue.

## But where's the music? The directories and ingame menus are empty! 

For copyright reasons, I cannot distribute the addon with Spyro music, but the code is prepared to register, name, display and play the music ingame once the end user (you) adds the appropiate music files in proper directories inside the addon. Please refer to the [How to add Spyro music](#how-to-add-spyro-music) and [How to add custom music and SFX](#how-to-add-custom-music-and-sfx) sections for a tutorial. It's easy, I promise, I've tried to write down every single step. Contact me if you have trouble, I'll do my best to help.

## How it works (skip ahead if you just want a step by step tutorial)

The addon sees music files ingame thanks to the LibSharedMedia-3.0 library. This approach requires two things:
- the sound file must be inside the DragonSpeedway_Music directory ( **World of Warcraft\\_retail\_\Interface\AddOns\DragonSpeedway\_Music\\** ) in preprovisioned directories (**Music** and **Sounds**),
- the music must be registered in the code itself (file **DragonSpeedway-LSM.lua** for Spyro music/sounds and file **DragonSpeedway-CustomMusic.lua** for custom music/sounds).

All sound files must be in either **.mp3** or **.ogg** format. No exceptions.

The Spyro-related code in **DragonSpeedway-LSM.lua** file is already done - you will simply need to add the music files in the correct directories and name them as stated in the addon - no exceptions, even capitalization matters, but you can also modify the code to accept your naming conventions (why would you do that tho).

The **DragonSpeedway-CustomMusic.lua** file contains proper sections and tldr explanations on how to modify them to accept custom music. Either refer to them or just follow with the tutorials below.

## How to add Spyro music

1. Download the addon (if you haven't already) - either use an addon manager or manually place the **DragonSpeedway** and **DragonSpeedway_Music** addon folders inside **World of Warcraft\\_retail\_\Interface\AddOns\\**.
2. Go inside the addon directory - **DragonSpeedway_Music**.
3. Go inside the **Music** directory.
4. Go inside **Spyro Reignited 1** directory and add your music files in **.mp3** format. It does NOT have to be Reignited versions, you can use classic music if you prefer. These files **HAVE TO** follow this naming convention:
```
crystal-flight.mp3
icy-flight.mp3
night-flight.mp3
sunny-flight.mp3
wild-flight.mp3
```
5. Go back to **Music** directory.
6. Repeat step **4.** for **Spyro Reignited 2** and **Spyro Reignited 3** directories. For reference, here are the file names for Spyro 2:
```
canyon-speedway.mp3
icy-speedway.mp3
metro-speedway.mp3
ocean-speedway.mp3
```
and Spyro 3:
```
country-speedway.mp3
harbor-speedway.mp3
honey-speedway.mp3
mushroom-speedway.mp3
```
7. RESTART THE GAME! These files won't be visible with a simple */reload*, you need to restart the entire game client!
8. You're done, Spyro music should now be displayed in addon's settings in the game. Pick the ones you like, you can also mute certain sounds if you want to, for example, play music without any sound effects.

## How to add custom music and SFX

1. Download the addon (if you haven't already) - either use an addon manager or manually place the **DragonSpeedway** and **DragonSpeedway_Music** addon folders inside **World of Warcraft\\_retail\_\Interface\AddOns\\**.
2. Go inside the addon directory - **DragonSpeedway_Music**.
3. Go inside the **Music** directory.
4. Go inside **Custom** directory and add your **music** files in either **.mp3** or **.ogg** format. These files can be named however you like, just don't use special characters - I can't guarantee they will work.
5. Go back to the addon directory - **DragonSpeedway_Music**.
6. Go inside **Sounds** directory.
7. Go inside **Custom** directory and add your **sound** files in either **.mp3** or **.ogg** format. These files can be named however you like, just don't use special characters - I can't guarantee they will work.
8. Go back to the addon directory - **DragonSpeedway_Music**.
9. Open **DragonSpeedway-CustomMusic.lua** file in your text editor of choice - Notepad is fine.
10. Read the comments with an explanation on how to register your custom music files. Refer to them in the future when adding/removing more files.
11. You will need to add a separate code line for each file you've added. There are commented sections for readability:
```
-- Custom music

-- <place the code here>


-- Custom sound effects

-- <place the code here>
```
but you don't have to use them if you don't want to. You can place your code at the end of the file.

12. The code has the following format:
```
LSM:Register("sound", <name of the music, will be displayed ingame>, [[file path to the music file]])
```

13. Copy-paste the aforementioned code into the opened file.
14. Replace **<name of the music, will be displayed ingame>** with the name of the music/sound - it can be anything you want (no special characters!) and will be displayed in the game. 
15. Replace **file path to the music file** with the file path to your music/sound file. It **HAS TO** follow the following format for **music** files:
```
Interface\Addons\DragonSpeedway_Music\Music\Custom\name-of-music-file.mp3
```
and this format for **sound** files:
```
Interface\Addons\DragonSpeedway_Music\Sounds\Custom\name-of-sound-file.mp3
```

16. Your code line should look similar to these examples:
```
LSM:Register("sound", "Crystal Flight", [[Interface\Addons\DragonSpeedway_Music\Music\Custom\crystal-flight.mp3]])

LSM:Register("sound", "Tu tu ru tuuu", [[Interface\Addons\DragonSpeedway_Music\Sounds\Custom\fanfare-sound.mp3]])
```

17. Repeat steps **13, 14, 15** for every single music/sound file you've added.
18. RESTART THE GAME! These files won't be visible with a simple */reload*, you need to restart the entire game client!
19. You're done, your custom music should now be displayed in addon's settings in the game. Pick the ones you like, you can also mute certain sounds if you want to, for example, play music without any sound effects.

## Authors

* [Shushuda](https://github.com/Shushuda)

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details

## Acknowledgements

* [Elkano](https://www.curseforge.com/members/elkano/) for [LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)
* [nevcairiel](https://www.curseforge.com/members/nevcairiel/) for [CallbackHandler-1.0](https://www.curseforge.com/wow/addons/callbackhandler)
* Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel and joshborke for [LibStub](https://www.curseforge.com/wow/addons/libstub)
* [WoWpedia](https://wowpedia.fandom.com/) for their knowledge base and tutorials
