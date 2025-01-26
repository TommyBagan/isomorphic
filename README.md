<p align="center">
<img src="https://github.com/TommyBagan/isomorphic/blob/main/logo_scaled.png" width="128">
</p>

# Isomorphic Repository

## Description

This is a Minecraft datapack & resource pack library, which aims to persist current item behaviours with the base game, whilst reducing the `minecraft` item namespace to permit usage of those freed ids by datapack developers.

## Installation

Simply take the Isomorphic zip, and put one copy in your world's datapack folder, and another in your resource pack folder!

## Benefits

### Datapack developers can use the item names for custom crafting recipes

Mojang have yet to enhance the game so recipes can match against a item-component predicate, or introduce completely data-driven items. Until that is done, it is difficult to have a custom item used as a recipe ingredient, without removing a pre-existing item. However with Isomorphic, datapack developers can freely use any of the freed `minecraft:...` item ids for their own custom items, and use those items as recipe ingredients without concern.

*Here's an example, you can see the item is the Cat Music Disc and behaves as so, but is actually the base item minecraft:music_disc_5 under the hood:*

![image](https://github.com/user-attachments/assets/90a63b52-b609-4ac3-89c4-938908657cc5)

### Hidden from players

Survival players shouldn't even notice any change to their game whatsoever. Isomorphic does not remove features, but have reworked minecraft's datapacks in our favour.

### Compatible updates between datapack versions

All manipulated vanilla items (listed in the *Freed Namespace* list) are given an associated `"actual_id"`. Isomorphic uses the id to track the items, so that we can provide upgrade routines to alter their components, should item behaviour change between MC versions.

## Limitations

### Datapack developers can't use the base item id in crafting recipes

Again due to Mojang's current datapack system, using Isomorphic's base item `minecraft:music_disc_5` in a recipe will be an issue, as any survival obtained item (say a poisonous_potato), could be used.

### Users have to

### Custom resource pack item models can conflict

Each item listed in the freed namespace has a custom model. This was made so that looking at custom recipes in the recipe book still shows the

### Not made for creative mode

Most datapacks that implement custom items don't have creative mode in mind anyway, so this is not really a limitation but still worth mentioning.s

## Freed Namespace

As of our release 1.21.3_0, there are 21** item IDs available for use:

- `minecraft:diamond_horse_armor`*
- `minecraft:music_disc_11`
- `minecraft:music_disc_13`
- `minecraft:music_disc_blocks`
- `minecraft:music_disc_cat`
- `minecraft:music_disc_chirp`
- `minecraft:music_disc_creator_music_box`
- `minecraft:music_disc_creator`
- `minecraft:music_disc_far`
- `minecraft:music_disc_mall`
- `minecraft:music_disc_mellohi`
- `minecraft:music_disc_otherside`
- `minecraft:music_disc_pigstep`
- `minecraft:music_disc_precipice`
- `minecraft:music_disc_relic`
- `minecraft:music_disc_stal`
- `minecraft:music_disc_strad`
- `minecraft:music_disc_wait`
- `minecraft:music_disc_ward`
- `minecraft:poisonous_potato`
- `minecraft:totem_of_undying`

- These items must be obtained via using the corresponding extension datapack.
** Including the extension datapack(s).

*Here is a picture of all 20 freed item ids:*

![image](https://github.com/user-attachments/assets/df571a85-4c9f-471b-9fc0-d78e3fcb17bb)

## FAQ

### "I need more custom items! Please add more!"

This datapack takes a maximalist approach, meaning we attempt to free up as much of the namespace as possible, within the bounds of maintaining vanilla behaviours. However, I do post suggestions for Mojang to enable more items:

- <https://feedback.minecraft.net/hc/en-us/community/posts/31965845874445-Data-Driven-Goat-Horn-Ram-Loot>

### "How do we know if an item name is freeable?"

Isomorphic can free an item id if is matches all these criteria:

- It isn't an ingredient for any vanilla recipe.
- The item is completely data-driven, meaning its native behaviour can be recreated with its components in `items.json` (the referenced file can be found via unzipping Mojang's `server.jar`).
- Any methods of obtaining the item is completely data driven.

### "Where did you get this idea?"

The original inspiration was Conure's Video ["What is the best "dummy" item in Minecraft?"](https://www.youtube.com/watch?v=UnOqaohypyQ&t=304s) - check his channel out!

### "How does it actually work?"

We have manipulated all obtaining and usage of the items to act the exact same as vanilla, but with the same base item id `music_disc_5`. Most of the heavy lifting is done vi Mojang's datapack component system, which we use to replicate each item's behavior.

### "Why the name Isomorphic?"

## Attribution

We'd like to thank the following people for use of their works:

- Thank you to "\_daggsy\_", for  the textures from her resource pack [Flower Crowns](https://modrinth.com/resourcepack/flower-crowns).
