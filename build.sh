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
    echo "ERROR: Incorrect arguments specified for check_output."
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
  preamble='tellraw @s [{"translate": "Giving ","color": "gray"},{"translate": "$target:$custom_item","color": "green"}]'
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

copy_target mod_prospective
check_output mod_prospective

copy_target mod_floristic
generate_give_item_logic mod_floristic music_disc_5 floristic rose_circlet
substitute_refs mod_floristic components_rose_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic allium_circlet
substitute_refs mod_floristic components_allium_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic azalea_circlet
substitute_refs mod_floristic components_azalea_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic azure_circlet
substitute_refs mod_floristic components_azure_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic cornflower_circlet
substitute_refs mod_floristic components_cornflower_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic dandelion_circlet
substitute_refs mod_floristic components_dandelion_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic lilac_circlet
substitute_refs mod_floristic components_lilac_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic lily_circlet
substitute_refs mod_floristic components_lily_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic orange_tulip_circlet
substitute_refs mod_floristic components_orange_tulip_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic orchid_circlet
substitute_refs mod_floristic components_orchid_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic oxeye_circlet
substitute_refs mod_floristic components_oxeye_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic peony_circlet
substitute_refs mod_floristic components_peony_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic pink_tulip_circlet
substitute_refs mod_floristic components_pink_tulip_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic poppy_circlet
substitute_refs mod_floristic components_poppy_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic red_tulip_circlet
substitute_refs mod_floristic components_red_tulip_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic sunflower_circlet
substitute_refs mod_floristic components_sunflower_circlet
generate_give_item_logic mod_floristic music_disc_5 floristic white_tulip_circlet
substitute_refs mod_floristic components_white_tulip_circlet
generate_give_item_logic mod_floristic music_disc_11 floristic wither_rose_circlet
substitute_refs mod_floristic components_wither_rose_circlet
check_output mod_floristic

combine core IsomorphicCore$release.zip
combine ext_dha IsomorphicExtDHA$release.zip
combine mod_prospective Prospective$release.zip
combine mod_floristic Floristic$release.zip

echo "Build Successful!"
echo 