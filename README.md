# DragonSpeedway
A World of Warcraft addon playing custom music and sound effects when racing using the new Dragon Riding mechanic. It works with both time trials and multiplayer races.

This addon is mostly meant to be used with Spyro Flight/Speedway music and sound effects, but it also works with custom music and sound effects - sky's the limit.

## But where's the music? The directories and ingame menus are empty! 

For copyright reasons, I cannot distribute the addon with Spyro music, but the code is prepared to register, name, display and play the music ingame once the end user (you) adds the appropiate music files in proper directories inside the addon. Please refer to the "How to add Spyro music and SFX" and "How to add custom music and SFX" sections for a tutorial. It's easy, I promise. Contact me if you have trouble, I'll do my best to help.

## How it works (skip ahead if you just want a step by step tutorial)

The addon sees music files ingame thanks to the LibSharedMedia-3.0 library (bless the author for writing it, seriously). This approach requires two things:
- the sound file must be inside the Addon's directory ( **World of Warcraft\\_retail\_\Interface\AddOns\DragonSpeedway\\** ) in preprovisioned directories (**Music** and **Sounds**),
- the music must be registered in the code itself (file **DragonSpeedway-LSM.lua** for Spyro music/sounds and file **DragonSpeedway-CustomMusic.lua** for custom music/sounds).
All sound files must be in either **.mp3** or **.ogg** format. No exceptions.
The Spyro-related code in **DragonSpeedway-LSM.lua** file is already done - you will simply need to add the music files in the correct directories and name them as stated in the addon - no exceptions, even capitalization matters, but you can also modify the code to accept your naming conventions (why would you do that tho).
The **DragonSpeedway-CustomMusic.lua** file contains proper sections and tldr explanations on how to modify them to accept custom music. Either refer to them or just follow with the tutorials below.

## How to add Spyro music and SFX

TODO

## How to add custom music and SFX

TODO

## Authors

* **Weronika Sikora** - [Shushuda](https://github.com/Shushuda)

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details

## Acknowledgements

* [Elkano](https://www.curseforge.com/members/elkano/) for [LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)
* [nevcairiel](https://www.curseforge.com/members/nevcairiel/) for [CallbackHandler-1.0](https://www.curseforge.com/wow/addons/callbackhandler)
* Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel and joshborke for [LibStub](https://www.curseforge.com/wow/addons/libstub)
