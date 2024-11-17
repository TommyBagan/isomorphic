#!/bin/bash

usage() {
  echo "usage: overlay.sh [OPTION] [WORLD-SAVE]"
  echo "Overlays the datapack and resource pack into Minecraft [WORLD-SAVE]."
}

if [[ $# -eq 0 ]] || [[ $# -ge 3 ]]; then
  echo "ERROR: Unexpected number of arguments"
  echo
  usage
  exit 1
fi

build=false
save=$1
if [[ $1 -eq '-b' ]]; then
  build=true
  save=$2
fi

if [[ -z $save ]]; then
  echo "ERROR: Must specify the [WORLD-SAVE]."
  echo
  usage
  exit 2
fi

MC_DIR=~/.minecraft

if [[ ! -d "$MC_DIR/saves/$save" ]]; then
  echo "ERROR: Found no Minecraft world save $save."
  echo
  usage
  exit 3
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ $build = true ]]; then
  $SCRIPT_DIR/build.sh
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Couldn't build the packs."
    echo
    usage
    exit 4
  fi
fi

OUT_DIR=$SCRIPT_DIR/out

if [[ ! -f "$OUT_DIR/isomorphic_data.zip" ]] || [[ ! -f "$OUT_DIR/isomorphic_resc.zip" ]]; then
  echo "ERROR: Couldn't find both build output zips under $OUT_DIR."
  echo
  usage
  exit 5
fi

cp -f "$OUT_DIR/isomorphic_data.zip" "$MC_DIR/saves/$save/datapacks/"
cp -f "$OUT_DIR/isomorphic_resc.zip" "$MC_DIR/resourcepacks/"

echo "Overlay Successful!"
echo