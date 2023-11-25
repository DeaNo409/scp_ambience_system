
# SCP Ambience System

So this is the Ambience System, which adds some random playing Ambience Sound. Some of them are just scary and most of them are from SCP: CB and SCP: SL.


## License

[Apache](http://www.apache.org/licenses/)
If you use this in your project please give credits. If you want to modify this and upload it to the workshop, ask me first.

## Installation

Installing and changing the Chances + Cooldown (Editors like Visual Studio Code will make it more easy)

  1. install this

  2. Put it in this folder: GarrysMod\garrysmod\addons
  -> You can find it, if you press right click on gmod in your Steam library 
  and then search local data or something. It will bring you to this folder

### Changing Chances
Changing the Chance that a sound will play after the Cooldown

1. go to this folder: GarrysMod\garrysmod\addons\scp_ambient_sfx\lua\autorun\server

2. Open the file and search for this in Line 73:
```bash
      if math.random(1, 80) == 1 then -- Change the 80 to something you like. Here it is 1 to 80 . Make it higher to make it more rare and lower to make it more common
```
### Changing Cooldown
Well this is quite easy
search for this in Line 55:
```bash
  local cooldownTime = 60 -- This makes so that every 60 seconds a sound will be played at a chance of 1/80
```
## Support

For support or suggestions: [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3094576368)

