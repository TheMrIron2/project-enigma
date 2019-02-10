# Project Enigma

"Project Enigma" (working title) is a multiplayer-focused World War II game built on a heavily modified Quake engine.

## Platforms

- PC
- PSP
- PS Vita
<!--- Wii
 Wii U

## Features

- Up to 8 players in one game, with online multiplayer and local Ad-Hoc supported^!
- Bots!
- Cross-platform multiplayer!
- Over a dozen of your favourite WW2 weapons to choose from!
- Different loadouts for Axis and Allies!

And more!

^Ad-Hoc is only applicable to PSP and Vita.-->

### Coming Soon.

# Compilation

## PC
1. Make sure `gcc` is installed on your target platform.
2. `cd` to <respository directory>/Source/PC-Engine/engine
3. `make gl-rel -j4`
4. `cd ..`
5. `engine/relese/fteqw.gl -nohome`

## PSP
1. Install [PSPToolchain Revision 2494](http://psp.jim.sh/svn/listing.php?repname=psp&path=%2Ftrunk%2Fpsptoolchain%2F&#ac0edc5d5b4c8077b690ec51d490e5fbe) (recommended by Insomnia-ProQuake developers)
2. `cd Source/PSP-Engine/psp`
3. `make`
4. EBOOT will be located in `psp/normal`

## PS Vita
1. Install the [Vita SDK](https://vitasdk.org/)
2. Download [vitaGL](https://github.com/Rinnegatamante/vitaGL) and do a `make install`
3. `cd /Source/Vita-Engine`
4. `make`

<!--## Wii
1. Grab [devkitPPC](https://devkitpro.org/wiki/Getting_Started/devkitPPC) for your platform, and this source.
2. `make`
3. If all is successful, you'll have `QuakeGX.dol` and `QuakeGX.elf` in <repository directory>/Wii. Rename the dol to `boot.dol` and you'll be good to slap it on a SD.-->
