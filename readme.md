Here's your updated README with the new ConVars included:

---

# PURE CHAOS - TTT2 Weapon

## Overview

**PURE CHAOS** is a powerful traitor weapon for **Trouble in Terrorist Town 2 (TTT2)** in **Garry's Mod**. Inspired by Scarlet Witch, this ultimate ability allows the user to hover and unleash chaos, damaging all enemies within range.
Please mind that I did not include the icon `materials/Scarlet_Witch.png` and the sound `gamemodes/terrortown/content/sound/pure_chaos.ogg` (see .gitignore) into this repository!

## Features

* **Flight Ability:** Gain the ability to hover and move freely in the air.
* **AOE Damage:** After a short delay, nearby enemies take massive damage.
* **Fall Damage Immunity:** Prevents fall damage while active.
* **Enemy Highlighting:** Marks enemies in range while in effect.
* **Custom Sound & Icon:** Includes a unique activation sound and an in-game icon.
* **Sound Toggle:** Ability to switch between the default sound and an alternative sound (provided by kller).

## Installation
subscribe to https://steamcommunity.com/sharedfiles/filedetails/?id=3421161653

OR 
1. Download or clone the repository into your **Garry's Mod** addons directory:
   ```
   garrysmod/addons/ttt2_purechaos/
   ```
2. Add the icon `materials/Scarlet_Witch.png`
3. Add the sound `gamemodes/terrortown/content/sound/pure_chaos.ogg`
4. (Ensure your **TTT2** gamemode is installed and active.)
5. Restart your server to apply changes.

There is a possibility for an alternative sound to play. This is the sound `gamemodes/terrortown/content/sound/pure_chaos_kller.ogg`. It's named like that, as the alternative version currently in use is provided by kller. This file is also actually included in this repo.
The in-game settings menu includes a toggle and a client-side override. The client ConVar `purechaos_use_alt_sound_override`, which is accessible in the console, is also a possibility:

* `-1`: Follows the server setting.
* `0`: Force off the alternative sound.
* `1`: Force on the alternative sound.

## Usage

* **Slot:** 7
* **Activation:** Primary fire
* **Effect Duration:** 5 seconds (damage occurs after 4 seconds)
* **Cooldown:** Cannot be reused after activation (one-time use per purchase)
* **Controls:**

  * Jump (SPACE) to ascend
  * Crouch (CTRL) to descend

## Configuration (CVARs)

Server owners can tweak the weapon settings using the following console variables:

| ConVar                             | Default | Description                                                                                            |
| ---------------------------------- | ------- | ------------------------------------------------------------------------------------------------------ |
| `purechaos_range`                  | 4000    | Range in units for AOE damage.                                                                         |
| `purechaos_verticalpower`          | 30      | Upward/downward movement force.                                                                        |
| `purechaos_damage`                 | 110     | Damage dealt to enemies in range.                                                                      |
| `purechaos_use_alt_sound`          | 0       | Toggle for alternative sound: 0 = default sound, 1 = alternative sound.                                |
| `purechaos_use_alt_sound_override` | -1      | Override for client-side sound setting: -1 = use server setting, 0 = off, 1 = force alternative sound. |

Modify these values in **server.cfg** or in-game using:

```
sv_purechaos_range 5000
sv_purechaos_damage 120
sv_purechaos_use_alt_sound 1
sv_purechaos_use_alt_sound_override 0
```

## Addon Menu

A settings menu is available under the **TTT2 Server Addons** section, allowing you to easily adjust values.

## Changelog

### Version 1.1
* No more damage after Death of Player. 
* Replace pure chaos sound with a little joke, provided by kller.
* Stop sound on death.
* Make the alternative sound toggle-able and also client overridable.

### Version 1.0

* Initial release with full weapon functionality.
* Includes flight, AOE damage, and fall damage immunity.
* Steam version: 12 Feb @ 9:48pm

## Credits

* **Author:** Neolyum

## License

This addon is provided as-is. You are free to modify and distribute it with proper credits.

---

Enjoy causing **PURE CHAOS** in your TTT2 games!

---

This version now includes the new ConVars for managing the alternative sound and its override, making it clear for both server admins and clients how to configure the weapon. Let me know if you need any other adjustments!

