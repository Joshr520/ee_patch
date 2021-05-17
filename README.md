# ee-patch

# WARNING

This patch is currently a work in progress, and does not have any official release yet. You can download and use the patch, but nothing is guaranteed to be setup correctly and not everything is expected to work yet.

# Patch Information

A patch for Black Ops 3 Zombies that modifies many aspects of the game, such as rng for easter eggs and hud elements

Massive credit to - This is KB can I help you - for providing the structure of the codebase, as well as contributing many scripts. Also a big thanks to working with me on this project and providing a great learning experience.

To compile the patch on your own: Go to steam -> library -> at the top left under home, click the drop down menu and select tools -> download the Call of Duty Black Ops III - Mod Tools -> launch mod tools -> find the patch and check zm_mod -> check link at the right -> press build -> your patch will compile and any errors will be shown below or at runtime in game.

If your patch isn't there, you need to put it in your mods folder in the Black Ops III directory (make one if you don't have one). The Mod Tools will show the patch if it's formatted correctly.

To edit the patch, follow this video - https://youtu.be/vFr9DFstF9w - to setup Sublime Text for coding.

To view function documentation, find your Black Ops III root directory, locate the docs_modtools folder, open bo3_scriptapifunctions.htm. This includes many functions you can use to edit game mechanics.

# Code Structure

## Random Functions

Located in scripts/shared, the array_shared.gsc file contains 2 functions - random and randomize - which are used by the game to determine many rng factors. These functions are modified to loop through the defined overrides and execute them if the conditions are met.

## Array Overrides

Located in scripts/zm/array_override, all of the files that will be passed into the random functions are placed here. They must register the override using the macro REGISTER_OVERRIDE and then unregister using the macro UNREGISTER_OVERRIDE once all functionality is ceased. The files are separated between specific maps and things that effect multiple maps. Note the pre_spawn_overrirdes.gsh file is used to modify rng that happens immediately at the start of the game, because otherwise it won't work. Only use this file if you've manipulated something and you're sure it's not changing in game.

## Script Overrides

Located in scripts/zm/script_override, these files modify certain aspects of scripts. Use this folder for script modifications that don't include the random functions and editing specific variables for a map.

## Variable Overrides

located in scripts/zm/variable_override, these files modify specific variables for maps. Notably, the file fixed_special_rounds.gsc is contained here, which modifies the unique enemy round for each map. Use this folder for editing specific variables that determine rng on maps.

## Craftables

scripts/zm/craftables/_zm_craftables.gsc uses the variable - level.get_fixed_craftable_location - to determine if a part should have a specific spawn point. This variable is defined in the scripts/zm//script_override/craftable_locations.gsc file, which determines common part location spawns.

## HUD

Used for HUD elements such as the zombie counter and timer, still has a lot of WIP material being constructed.

## Compilation Files

This is used for holding base game scripts which are needed for compilation. Sometimes, we can't edit directly what we are wanting to from another file, so the base game script is modified and included in the zone file. These files typically require a few other files to be in the folder to compile, so they are stored here and can be moved to the scripts/zm folder when you want to compile them. This is purely to keep better organization and not clutter the main folder with useless files that aren't being edited.

## Zone File

The zone file is located at zone_source/zm_mod.zone. It's used to tell the compiler which files are being used. You can follow the format already present if you want to add more files.
