*This tool doesn't have any releases yet. The repository is public to document my progress and contact modders about the project easily.*

<img align="left" width="64" height="64" src="https://github.com/user-attachments/assets/f7a0c6c2-6551-45c5-9b6e-698d5f31d76c" alt="ST icon">

# The Sims 3 Starter Tool

![Current Version](https://img.shields.io/github/v/release/swiffyjk/ts3-starter-tool?label=current%20version) ![GitHub all releases](https://img.shields.io/github/downloads/swiffyjk/ts3-starter-tool/total?label=total%20downloads)

This tool is a Windows installer that applies various fixes to The Sims 3's game files, gives you a Mods folder, and patches the game so it can run on modern systems.  

## Frequently Asked Questions  
### What version of the game do I need?
The latest version of the game on Steam or the EA App. (these auto-update, so don't worry about trying to check for updates!)  
Disc/Retail copies of the game also work just as well, but you'll need to [use the Super Patcher](http://akamai.cdn.ea.com/eadownloads/u/f/sims/sims3/patches/TS3_1.67.2.0240xx_update.exe) to make sure you're on 1.67 first.  
If you know how to find your game version, this should be either 1.67 or 1.69. Both will work. 
### Will this be on macOS?  
For the foreseeable future - no. The Sims 3 shouldn't require any fixes to *run* on macOS, but I definitely understand that you may want the fix mods it comes with.  
Unfortunately, I do not have a Mac to test this with, so for now I'd recommend going to the links for the fixes yourself, and seeing if they're compatible with the macOS version of the game.  
### Does this tool install The Sims 3 game and all DLCs, like the TS1/TS2 Starter Pack?  
*No.* As The Sims 3 is still legitimately digitally obtainable, I cannot bundle the game nor its purchasable DLCs in this starter pack.  
The Katy Perry Sweet Treats pack is an exception to this rule, as it is *not legitimately digitally obtainable*, and is therefore considered abandonware. This pack can optionally be installed using the tool.  
### What features are currently included?  
\**Not enabled by default*
#### Experimental - testing features  
- Installs the Katy Perry Sweet Treats pack (abandonware)\*
#### Placeholder features  
- Installs a ready-to-use mods folder layout
- [Installs LazyDuchess' Smooth Patch](https://modthesims.info/d/658759/smooth-patch-2-1.html)
- Updates the game's GPU database with modern graphics cards
- Increases CPU usage for low-mid range CPUs
- Fixes incorrect amount of VRAM being used
- [Patches game to run on new Intel CPUs with LazyDuchess' Intel Alder Lake Patch](https://modthesims.info/d/667734/intel-alder-lake-patch.html)
- Disables network connectivity to reduce unnecessary lag\*
#### Long-term future features  
- [Simler90's Gameplay Fixes](https://modthesims.info/d/659969/simler90-s-gameplay-core-mod.html) [(with warnings for NRaas users)](https://www.nraas.net/community/announcements/topic11969)
- Options.ini persistence script, prevents GPU updates resetting options
- Some sort of mini-browser to install mods that don't want to be redistributed
### Modders & creators:
If you'd like to get involved, please make a pull request, issue or [contact me on ModTheSims](https://modthesims.info/member.php?u=10346421).  
All mods used either:
- Have personal permission from the creators themselves to be used
- Are from creators with TOUs that permit their creations to be redistributed
- Are from other creators, but are installed through their official source using a web browser (and therefore not actually redistributed). This is currently not implemented.
