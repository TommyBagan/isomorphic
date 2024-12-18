#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build
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

combine core IsomorphicCore$release.zip
combine ext_dha IsomorphicExtDHA$release.zip

echo "Build Successful!"
echo 