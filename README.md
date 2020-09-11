# No More Friendly Fire #

## Description ##
Stops friendly fire. Player companions can't damage the player, the player can't damage companions, and companions can't damage each other.

I got tired of accidentally killing my guar companions, blowing up my fighter companions, and getting blown up by my mage companions, so I wrote this little script.

The script keeps a cached list of followers that is refreshed at the following instances:
* Player changes cells
* Player tells follower to follow or wait
* Player casts conjuration spell

If you have [More Attentive Guards](https://www.nexusmods.com/morrowind/mods/48622) version 1.1.4 or greater installed, then following guards won't be counted as friendly by this mod.

As of version 1.4, there is an option to also stop any combat that would be started between followers.

## Known Issues ##
Doesn't stop experience gain, just zeros out the damage that would have been done. I'm not really sure this one _can_ be fixed.

## Requirements ##
MWSE 2.1 nightly @ [github](https://github.com/MWSE/MWSE)

## Credits ##

* MWSE Team for MWSE with Lua support

## License ##

MIT License. See LICENSE file.
