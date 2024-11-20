#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build

# usage() {
#   echo "usage: build.sh"
#   echo "Builds the datapack and resource pack into $OUT_DIR."
# }

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
  grep -rlZ \@$ref . | xargs -0 sed -i "/@$ref/r $ref_path"
  if [[ $? -ne 0 ]]; then 
    echo "ERROR: Failed to substitute definition $ref within $target."
    echo
    popd
    exit 3
  fi

  grep -rlZ \@$ref . | xargs -0 sed -i "s/@$ref//g"
  if [[ $? -ne 0 ]]; then 
    echo "ERROR: Failed to remove references to the object."
    echo
    popd
    exit 4
  fi
  popd
}

check_output() {
  if [[ $# -ne 1 ]]; then
    echo "ERROR: Incorrect arguments specified for check_output."
    exit 255
  fi
  output=$1
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
  tar -acf $output *
  if [[ $? -ne 0 ]] || [[ ! -f "./$output" ]]; then
    echo "ERROR: Failed to combine target $target."
    echo
    popd
    exit 2
  fi
  mv "./$output" "$OUT_DIR/"
  popd
}

if [[ $# -ne 0 ]]; then
  echo "ERROR: Unexpected number of arguments."
  echo
  exit 1      
fi

copy_target pack_data
copy_target pack_resc
substitute_refs pack_data components_diamond_horse_armor
# substitute_refs pack_data components_goat_horn
substitute_refs pack_data components_music_disc_11
substitute_refs pack_data components_music_disc_13
substitute_refs pack_data components_music_disc_blocks
substitute_refs pack_data components_music_disc_cat
substitute_refs pack_data components_music_disc_chirp
substitute_refs pack_data components_music_disc_creator_music_box
substitute_refs pack_data components_music_disc_creator
substitute_refs pack_data components_music_disc_far
substitute_refs pack_data components_music_disc_mall
substitute_refs pack_data components_music_disc_mellohi
substitute_refs pack_data components_music_disc_otherside
substitute_refs pack_data components_music_disc_pigstep
substitute_refs pack_data components_music_disc_precipice
substitute_refs pack_data components_music_disc_relic
substitute_refs pack_data components_music_disc_stal
substitute_refs pack_data components_music_disc_strad
substitute_refs pack_data components_music_disc_wait
substitute_refs pack_data components_music_disc_ward
substitute_refs pack_data components_poisonous_potato
substitute_refs pack_data components_totem_of_undying
check_output pack_data
combine pack_data isomorphic_data.zip
check_output pack_resc
combine pack_resc isomorphic_resc.zip

echo "Build Successful!"
echo 