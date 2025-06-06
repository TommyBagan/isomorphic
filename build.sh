#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build
COMMON_NAMESPACE=isomorphic
quiet_mode=false

usage() {
  if [[ $quiet_mode = false ]]; then
    echo "usage: build.sh [-q] [VERSION]"
    echo "Builds the datapack and resource pack into $OUT_DIR,"
    echo "and builds for release with the optional [VERSION];"
    echo "that is expected to be in example format 1.21.3v1."
    echo
    echo "  -q             Quiet mode, where usage is not outputted."
  fi
}

clear_output() {
  pushd $OUT_DIR
  ls | xargs rm -rf
  popd
}

copy_target() {
  if [[ $# -ne 1 ]]; then
    echo "ERROR: Incorrect arguments specified for copy_target."
    exit 255
  fi
  target=$1
  if [[ ! -d "$SCRIPT_DIR/$target" ]]; then
    echo "ERROR: Failed to find target $target."
    exit 255
  fi
  if [[ -d "$OUT_DIR/$target" ]]; then 
    rm -rf "$OUT_DIR/$target"
  fi
  cp -rf "$SCRIPT_DIR/$target" "$OUT_DIR/"
}

substitute_refs() {
  if [[ $# -ne 2 ]]; then
    echo "ERROR: Incorrect arguments specified for substitute_refs."
    echo
    exit 255
  fi
  target=$1
  ref=$2
  if [[ ! -d "$OUT_DIR/$target" ]]; then 
    echo "ERROR: Failed to find copied target $OUT_DIR/$target."
    echo
    exit 255
  fi
  ref_path="$SCRIPT_DIR/references/$ref.json"
  ls $ref_path
  if [[ ! -f $ref_path ]]; then 
    echo "ERROR: Failed to find referenced definition $ref_path."
    echo
    exit 255
  fi
  pushd "$OUT_DIR/$target"
  grep -r -l -Z --include=\*.{json,mcmeta} \@$ref . | xargs -0 sed -i "/@$ref/r $ref_path"
  if [[ $? -ne 0 ]]; then 
    echo "ERROR: Failed to substitute definition $ref within $target."
    echo
    popd
    exit 3
  fi

  grep -r -l -Z --include=\*.{json,mcmeta} \@$ref . | xargs -0 sed -i "s/@$ref//g"
  if [[ $? -ne 0 ]]; then 
    echo "ERROR: Failed to remove references to the object."
    echo
    popd
    exit 4
  fi
  popd
}

substitute_ref_in_file_to() {
  ref=$1
  file=$2
  new_value=$3
  if [[ $# -ne 3 ]]; then
    echo "ERROR: Incorrect arguments specified for substitute_ref_in_file_to."
    echo
    exit 255
  fi

  if [[ ! -f "$file" ]]; then 
    echo "ERROR: Specified file for substituion doesn't exist $file."
    echo
    exit 1
  fi

  sed -i "s/@$ref/$new_value/g" "$file"
  if [[ $? -ne 0 ]]; then 
    echo "ERROR: Failed to substitute @$ref for $new_value."
    echo
    exit 2
  fi
}

generate_give_item_logic() {
  if [[ $# -ne 4 ]]; then
    echo "ERROR: Incorrect arguments specified for generate_give_item_logic."
    exit 255
  fi
  target=$1
  item_id=$2
  namespace=$3
  custom_item=$4

  if [[ ! -d "$OUT_DIR/$target" ]]; then 
    echo "ERROR: Failed to find copied target $OUT_DIR/$target."
    echo
    exit 255
  fi
  components_ref=components_$custom_item
  ref_path="$SCRIPT_DIR/references/$components_ref.json"
  ls $ref_path
  if [[ ! -f "$ref_path" ]]; then
    echo "ERROR: Failed to find referenced item components $ref_path."
    echo
    exit 255
  fi

  generic_loot_table="$SCRIPT_DIR/references/generics/item_loot.json"
  if [[ ! -f "$generic_loot_table" ]]; then 
    echo "ERROR: Failed to find predefined generic loot table $generic_loot_table."
    echo
    exit 255
  fi
  
  namespace_dir="$OUT_DIR/$target/data/$namespace"
  if [[ ! -d "$namespace_dir" ]]; then
    echo "ERROR: Didn't find namespace $namespace within $target."
    echo
    exit 255
  fi
  
  unique_folder=$COMMON_NAMESPACE\_item
  func_dir="$namespace_dir/function/$unique_folder"
  if [[ ! -d "$func_dir" ]]; then 
    mkdir --parents "$func_dir"
  fi
  preamble="tellraw @s [{\"translate\": \"Giving \",\"color\": \"gray\"},{\"translate\": \"$namespace:$custom_item\",\"color\": \"green\"}]"
  function="loot give @s loot $namespace:$unique_folder/$custom_item"
  echo "$preamble" > "$func_dir/give_$custom_item.mcfunction"
  echo "$function" >> "$func_dir/give_$custom_item.mcfunction"

  loot_dir="$namespace_dir/loot_table/$unique_folder"
  if [[ ! -d "$loot_dir" ]]; then 
    mkdir --parents "$loot_dir"
  fi
  loot_table="$loot_dir/$custom_item.json"
  cp "$generic_loot_table" "$loot_table"
  
  substitute_ref_in_file_to minecraft_item "$loot_table" $item_id
  substitute_ref_in_file_to components "$loot_table" @$components_ref
}

generate_recipe_advancement() {
  if [[ $# -le 4 ]]; then
    echo "ERROR: Incorrect arguments specified for generate_recipe_advancement."
    exit 255
  fi
  target=$1
  recipe_id=$2
  namespace=$3
  recipe_category=$4
  shift 4
  if [[ $# -eq 0 ]]; then
    echo "ERROR: No dependencies suffixed for generate_recipe_advancement."
    exit 255
  fi

  if [[ ! -d "$OUT_DIR/$target" ]]; then 
    echo "ERROR: Failed to find copied target $OUT_DIR/$target."
    echo
    exit 255
  fi

  namespace_dir="$OUT_DIR/$target/data/$namespace"
  if [[ ! -d "$namespace_dir" ]]; then
    echo "ERROR: Didn't find namespace $namespace within $target."
    echo
    exit 255
  fi

  category_dir="$namespace_dir/advancement/recipes/$recipe_category"
  if [[ ! -d "$category_dir" ]]; then
    mkdir --parents "$category_dir"
  fi

  recipe_adv="$category_dir/$recipe_id.json"
  if [[ -f "$recipe_adv" ]]; then
    echo "ERROR: Prexisting recipe already found for $recipe_adv."
    echo
    exit 255
  fi

  criteria=""
  requirements=""
  for dependency in "$@"
  do
    criteria+=",\"has_$dependency\":{\"conditions\":{\"items\":[{\"items\":\"minecraft:$dependency\"}]},\"trigger\":\"minecraft:inventory_changed\"}"
    requirements+=",\"has_$dependency\""
  done

  if [[ -z "$criteria" || -z "$requirements" ]]; then
    echo "ERROR: Couldn't construct criteria or requirements."
    echo
    exit 255
  fi

  generic_recipe_advancement="$SCRIPT_DIR/references/generics/recipe_advancement.json"
  if [[ ! -f "$generic_recipe_advancement" ]]; then 
    echo "ERROR: Failed to find predefined generic advancement $generic_recipe_advancement."
    echo
    exit 255
  fi
  
  cp "$generic_recipe_advancement" "$recipe_adv"

  substitute_ref_in_file_to recipe_id "$recipe_adv" $recipe_id
  substitute_ref_in_file_to namespace "$recipe_adv" $namespace
  substitute_ref_in_file_to criteria "$recipe_adv" $criteria
  substitute_ref_in_file_to requirements "$recipe_adv" $requirements
}

check_output() {
  if [[ $# -ne 1 ]]; then
    echo "ERROR: Incorrect arguments specified for check_output."
    exit 255
  fi
  target=$1
  pushd "$OUT_DIR/$target"
  leftovers=$(grep -r -l --include=\*.{json,mcmeta} @ .)
  if [[ ! -z $leftovers ]]; then
    echo
    echo "ERROR: Found dangling references!"
    echo $leftovers
    echo
    exit 5
    popd
  fi
  popd
}

combine() {
  if [[ $# -ne 2 ]]; then
    echo "ERROR: Incorrect arguments specified for combine."
    exit 255
  fi
  target=$1
  output=$2
  if [[ ! -d "$OUT_DIR/$target" ]]; then
    echo "ERROR: Failed to find combine target $target."
    exit 255
  fi
  pushd "$OUT_DIR/$target"
  if [[ -f "$OUT_DIR/$output" ]]; then
    rm "$OUT_DIR/$output"
  fi
  
  zip -r $output *
  if [[ $? -ne 0 ]]; then
    echo "Attempting with tar.exe..."
    tar.exe -acf $output *
    if [[ $? -ne 0 ]] || [[ ! -f "./$output" ]]; then
      echo "ERROR: Failed to combine target $target."
      echo
      popd
      exit 2
    fi
  fi 
  mv "./$output" "$OUT_DIR/"
  popd
}

resc_combine() {
  if [[ $# -le 2 ]]; then
    echo "ERROR: Incorrect arguments specified for group_combine."
    exit 255
  fi

  target=$1
  output=$2
  shift 2

  # Ensure pack target builds are clean.
  pushd "$OUT_DIR"
  if [[ -f "$OUT_DIR/$output" ]]; then
    rm "$OUT_DIR/$output"
  fi
  mkdir --parents "$OUT_DIR/$target/assets"

  # Loops through each pack, overlaying on top of target. 
  for pack in "$@"
  do
    if [[ -d "$OUT_DIR/$pack/assets" ]]; then
      cp -rf $OUT_DIR/$pack/assets/* $OUT_DIR/$target/assets/
    else
      echo "ERROR: Resource pack doesn't exist at $OUT_DIR/$pack/assets."
      popd
      exit 255
    fi
  done

  pushd "$OUT_DIR/$target"
  # Simply zip up the target folder.
  zip -r $output *
  if [[ $? -ne 0 ]]; then
    echo "Attempting with tar.exe..."
    tar.exe -acf $output *
    if [[ $? -ne 0 ]] || [[ ! -f "./$output" ]]; then
      echo "ERROR: Failed to combine the resource pack for $output."
      echo
      popd
      popd
      exit 2
    fi
  fi 
  mv "./$output" "$OUT_DIR/$output"

  popd
  popd
}

if [[ $# -gt 2 ]]; then
  echo "ERROR: Unexpected number of arguments."
  echo
  exit 1      
fi

if [[ $# -ge 1 ]]; then
  if [[ "$1" == "-q" ]]; then
    quiet_mode=true
    release=$2
  else
    release=$1
  fi
fi
if [[ ! -z $release ]]; then
  release=_$release
fi

### BUILD RULES
clear_output

copy_target core
substitute_refs core components_music_disc_11
substitute_refs core components_music_disc_13
substitute_refs core components_music_disc_blocks
substitute_refs core components_music_disc_cat
substitute_refs core components_music_disc_chirp
substitute_refs core components_music_disc_creator_music_box
substitute_refs core components_music_disc_creator
substitute_refs core components_music_disc_far
substitute_refs core components_music_disc_mall
substitute_refs core components_music_disc_mellohi
substitute_refs core components_music_disc_otherside
substitute_refs core components_music_disc_pigstep
substitute_refs core components_music_disc_precipice
substitute_refs core components_music_disc_relic
substitute_refs core components_music_disc_stal
substitute_refs core components_music_disc_strad
substitute_refs core components_music_disc_wait
substitute_refs core components_music_disc_ward
substitute_refs core components_poisonous_potato
substitute_refs core components_totem_of_undying
check_output core

copy_target ext_dha
substitute_refs ext_dha components_diamond_horse_armor
substitute_refs ext_dha components_music_disc_otherside
substitute_refs ext_dha components_music_disc_13
substitute_refs ext_dha components_music_disc_cat
check_output ext_dha

#copy_target ext_gh
#substitute_refs ext_gh components_goat_horn
#check_output ext_gh

# Curate
copy_target mod_curate
## Dash Stone
generate_give_item_logic mod_curate music_disc_5 curate dash_stone
substitute_refs mod_curate components_dash_stone
check_output mod_curate

# Prospective
copy_target mod_prospective
## Weak Upgrade
generate_give_item_logic mod_prospective music_disc_13 prospective weak_upgrade
generate_recipe_advancement mod_prospective weak_upgrade prospective misc deepslate resin_clump
substitute_refs mod_prospective components_weak_upgrade
## Wooden Tools
generate_give_item_logic mod_prospective wooden_axe prospective wooden_axe
substitute_refs mod_prospective components_wooden_axe
generate_give_item_logic mod_prospective wooden_pickaxe prospective wooden_pickaxe
substitute_refs mod_prospective components_wooden_pickaxe
generate_give_item_logic mod_prospective wooden_shovel prospective wooden_shovel
substitute_refs mod_prospective components_wooden_shovel
generate_give_item_logic mod_prospective wooden_hoe prospective wooden_hoe
substitute_refs mod_prospective components_wooden_hoe
generate_give_item_logic mod_prospective wooden_sword prospective wooden_sword
substitute_refs mod_prospective components_wooden_sword
## Leather Armors
generate_give_item_logic mod_prospective leather_helmet prospective leather_helmet
substitute_refs mod_prospective components_leather_helmet
generate_give_item_logic mod_prospective leather_chestplate prospective leather_chestplate
substitute_refs mod_prospective components_leather_chestplate
generate_give_item_logic mod_prospective leather_leggings prospective leather_leggings
substitute_refs mod_prospective components_leather_leggings
generate_give_item_logic mod_prospective leather_boots prospective leather_boots
substitute_refs mod_prospective components_leather_boots
## Stone Tools
generate_give_item_logic mod_prospective stone_axe prospective stone_axe
substitute_refs mod_prospective components_stone_axe
generate_give_item_logic mod_prospective stone_pickaxe prospective stone_pickaxe
substitute_refs mod_prospective components_stone_pickaxe
generate_give_item_logic mod_prospective stone_shovel prospective stone_shovel
substitute_refs mod_prospective components_stone_shovel
generate_give_item_logic mod_prospective stone_hoe prospective stone_hoe
substitute_refs mod_prospective components_stone_hoe
generate_give_item_logic mod_prospective stone_sword prospective stone_sword
substitute_refs mod_prospective components_stone_sword
## Iron Armors
generate_give_item_logic mod_prospective iron_helmet prospective iron_helmet
substitute_refs mod_prospective components_iron_helmet
generate_give_item_logic mod_prospective iron_chestplate prospective iron_chestplate
substitute_refs mod_prospective components_iron_chestplate
generate_give_item_logic mod_prospective iron_leggings prospective iron_leggings
substitute_refs mod_prospective components_iron_leggings
generate_give_item_logic mod_prospective iron_boots prospective iron_boots
substitute_refs mod_prospective components_iron_boots
## Iron Tools
generate_give_item_logic mod_prospective iron_axe prospective iron_axe
substitute_refs mod_prospective components_iron_axe
generate_give_item_logic mod_prospective iron_pickaxe prospective iron_pickaxe
substitute_refs mod_prospective components_iron_pickaxe
generate_give_item_logic mod_prospective iron_shovel prospective iron_shovel
substitute_refs mod_prospective components_iron_shovel
generate_give_item_logic mod_prospective iron_hoe prospective iron_hoe
substitute_refs mod_prospective components_iron_hoe
generate_give_item_logic mod_prospective iron_sword prospective iron_sword
substitute_refs mod_prospective components_iron_sword
## Gold Armors
generate_give_item_logic mod_prospective golden_helmet prospective golden_helmet
substitute_refs mod_prospective components_golden_helmet
generate_give_item_logic mod_prospective golden_chestplate prospective golden_chestplate
substitute_refs mod_prospective components_golden_chestplate
generate_give_item_logic mod_prospective golden_leggings prospective golden_leggings
substitute_refs mod_prospective components_golden_leggings
generate_give_item_logic mod_prospective golden_boots prospective golden_boots
substitute_refs mod_prospective components_golden_boots
## Gold Tools
generate_give_item_logic mod_prospective golden_axe prospective golden_axe
substitute_refs mod_prospective components_golden_axe
generate_give_item_logic mod_prospective golden_pickaxe prospective golden_pickaxe
substitute_refs mod_prospective components_golden_pickaxe
generate_give_item_logic mod_prospective golden_shovel prospective golden_shovel
substitute_refs mod_prospective components_golden_shovel
generate_give_item_logic mod_prospective golden_hoe prospective golden_hoe
substitute_refs mod_prospective components_golden_hoe
generate_give_item_logic mod_prospective golden_sword prospective golden_sword
substitute_refs mod_prospective components_golden_sword
## Diamond Armors
generate_give_item_logic mod_prospective diamond_helmet prospective diamond_helmet
substitute_refs mod_prospective components_diamond_helmet
generate_give_item_logic mod_prospective diamond_chestplate prospective diamond_chestplate
substitute_refs mod_prospective components_diamond_chestplate
generate_give_item_logic mod_prospective diamond_leggings prospective diamond_leggings
substitute_refs mod_prospective components_diamond_leggings
generate_give_item_logic mod_prospective diamond_boots prospective diamond_boots
substitute_refs mod_prospective components_diamond_boots
## Diamond Tools
generate_give_item_logic mod_prospective diamond_axe prospective diamond_axe
substitute_refs mod_prospective components_diamond_axe
generate_give_item_logic mod_prospective diamond_pickaxe prospective diamond_pickaxe
substitute_refs mod_prospective components_diamond_pickaxe
generate_give_item_logic mod_prospective diamond_shovel prospective diamond_shovel
substitute_refs mod_prospective components_diamond_shovel
generate_give_item_logic mod_prospective diamond_hoe prospective diamond_hoe
substitute_refs mod_prospective components_diamond_hoe
generate_give_item_logic mod_prospective diamond_sword prospective diamond_sword
substitute_refs mod_prospective components_diamond_sword
## Netherite Armors
generate_give_item_logic mod_prospective netherite_helmet prospective netherite_helmet
substitute_refs mod_prospective components_netherite_helmet
generate_give_item_logic mod_prospective netherite_chestplate prospective netherite_chestplate
substitute_refs mod_prospective components_netherite_chestplate
generate_give_item_logic mod_prospective netherite_leggings prospective netherite_leggings
substitute_refs mod_prospective components_netherite_leggings
generate_give_item_logic mod_prospective netherite_boots prospective netherite_boots
substitute_refs mod_prospective components_netherite_boots
## Netherite Tools
generate_give_item_logic mod_prospective netherite_axe prospective netherite_axe
substitute_refs mod_prospective components_netherite_axe
generate_give_item_logic mod_prospective netherite_pickaxe prospective netherite_pickaxe
substitute_refs mod_prospective components_netherite_pickaxe
generate_give_item_logic mod_prospective netherite_shovel prospective netherite_shovel
substitute_refs mod_prospective components_netherite_shovel
generate_give_item_logic mod_prospective netherite_hoe prospective netherite_hoe
substitute_refs mod_prospective components_netherite_hoe
generate_give_item_logic mod_prospective netherite_sword prospective netherite_sword
substitute_refs mod_prospective components_netherite_sword
## Chainmail Armors
generate_give_item_logic mod_prospective chainmail_helmet prospective chainmail_helmet
substitute_refs mod_prospective components_chainmail_helmet
generate_give_item_logic mod_prospective chainmail_chestplate prospective chainmail_chestplate
substitute_refs mod_prospective components_chainmail_chestplate
generate_give_item_logic mod_prospective chainmail_leggings prospective chainmail_leggings
substitute_refs mod_prospective components_chainmail_leggings
generate_give_item_logic mod_prospective chainmail_boots prospective chainmail_boots
substitute_refs mod_prospective components_chainmail_boots
## Handle Netherite Ingot changes
generate_recipe_advancement mod_prospective netherite_ingot_from_blasting_scrap prospective misc netherite_scrap ancient_debris
generate_recipe_advancement mod_prospective netherite_ingot_from_smelting_scrap prospective misc netherite_scrap ancient_debris
## Handle all Isomorphic substitions
substitute_refs mod_prospective components_music_disc_cat
substitute_refs mod_prospective components_music_disc_13
substitute_refs mod_prospective components_music_disc_otherside
substitute_refs mod_prospective components_music_disc_pigstep
substitute_refs mod_prospective components_poisonous_potato
check_output mod_prospective

# Floristic
copy_target mod_floristic
## Rose Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic rose_circlet
generate_recipe_advancement mod_floristic rose_circlet floristic combat rose_bush
substitute_refs mod_floristic components_rose_circlet
## Allium Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic allium_circlet
generate_recipe_advancement mod_floristic allium_circlet floristic combat allium
substitute_refs mod_floristic components_allium_circlet
## Azalea Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic azalea_circlet
generate_recipe_advancement mod_floristic azalea_circlet floristic combat flowering_azalea_leaves
substitute_refs mod_floristic components_azalea_circlet
## Azure Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic azure_circlet
generate_recipe_advancement mod_floristic azure_circlet floristic combat azure_bluet
substitute_refs mod_floristic components_azure_circlet
## Cornflower Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic cornflower_circlet
generate_recipe_advancement mod_floristic cornflower_circlet floristic combat cornflower
substitute_refs mod_floristic components_cornflower_circlet
## Dandelion Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic dandelion_circlet
generate_recipe_advancement mod_floristic dandelion_circlet floristic combat dandelion
substitute_refs mod_floristic components_dandelion_circlet
## Lilac Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic lilac_circlet
generate_recipe_advancement mod_floristic lilac_circlet floristic combat lilac
substitute_refs mod_floristic components_lilac_circlet
## Lily Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic lily_circlet
generate_recipe_advancement mod_floristic lily_circlet floristic combat lily_of_the_valley
substitute_refs mod_floristic components_lily_circlet
## Orange Tulip Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic orange_tulip_circlet
generate_recipe_advancement mod_floristic orange_tulip_circlet floristic combat orange_tulip
substitute_refs mod_floristic components_orange_tulip_circlet
## Orchid Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic orchid_circlet
generate_recipe_advancement mod_floristic orchid_circlet floristic combat blue_orchid
substitute_refs mod_floristic components_orchid_circlet
## Oxeye Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic oxeye_circlet
generate_recipe_advancement mod_floristic oxeye_circlet floristic combat oxeye_daisy
substitute_refs mod_floristic components_oxeye_circlet
## Peony Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic peony_circlet
generate_recipe_advancement mod_floristic peony_circlet floristic combat peony
substitute_refs mod_floristic components_peony_circlet
## Pink Tulip Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic pink_tulip_circlet
generate_recipe_advancement mod_floristic pink_tulip_circlet floristic combat pink_tulip
substitute_refs mod_floristic components_pink_tulip_circlet
## Poppy Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic poppy_circlet
generate_recipe_advancement mod_floristic poppy_circlet floristic combat poppy
substitute_refs mod_floristic components_poppy_circlet
## Red Tulip Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic red_tulip_circlet
generate_recipe_advancement mod_floristic red_tulip_circlet floristic combat red_tulip
substitute_refs mod_floristic components_red_tulip_circlet
## Sunflower Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic sunflower_circlet
generate_recipe_advancement mod_floristic sunflower_circlet floristic combat sunflower
substitute_refs mod_floristic components_sunflower_circlet
## White Tulip Circlet
generate_give_item_logic mod_floristic music_disc_5 floristic white_tulip_circlet
generate_recipe_advancement mod_floristic white_tulip_circlet floristic combat white_tulip
substitute_refs mod_floristic components_white_tulip_circlet
## Wither Rose Circlet
generate_give_item_logic mod_floristic music_disc_11 floristic wither_rose_circlet
generate_recipe_advancement mod_floristic wither_rose_circlet floristic combat wither_rose
substitute_refs mod_floristic components_wither_rose_circlet
## Tulip Bouquet
generate_give_item_logic mod_floristic music_disc_5 floristic tulip_bouquet
generate_recipe_advancement mod_floristic tulip_bouquet floristic tools red_tulip orange_tulip white_tulip pink_tulip
substitute_refs mod_floristic components_tulip_bouquet
## Floriography
generate_give_item_logic mod_floristic music_disc_5 floristic floriography
generate_recipe_advancement mod_floristic floriography floristic tools emerald emerald_block honey_bottle
substitute_refs mod_floristic components_floriography

check_output mod_floristic

copy_target iso_resc
check_output iso_resc
# This must be in order of precedence.
resc_combine iso_resc IsomorphicResourcePack$release.zip core mod_curate mod_floristic mod_prospective


combine core IsomorphicCore$release.zip
combine ext_dha IsomorphicExtDHA$release.zip
combine mod_prospective Prospective$release.zip
combine mod_floristic Floristic$release.zip
combine mod_curate Curate$release.zip

echo "Build Successful!"
echo 