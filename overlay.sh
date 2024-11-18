#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build

usage() {
  echo "usage: overlay.sh [OPTION] [WORLD-SAVE]"
  echo "Overlays the datapack and resource pack into Minecraft [WORLD-SAVE]."
  echo
  echo "  -b             Builds before overlaying."
  echo "  -w             Runs assuming a Windows Minecraft install."
}

if [[ $# -eq 0 ]] || [[ $# -ge 4 ]]; then
  echo "ERROR: Unexpected number of arguments"
  echo
  usage
  exit 1
fi

build=false
save=${@: -1}
if [[ "$*" == *"-b"* ]] then
  build=true
fi

export MC_DIR=~/.minecraft
if [[ "$*" == *"-w"* ]]; then
  export MC_DIR=$APPDATA/.minecraft
fi

if [[ -z $save ]]; then
  echo "ERROR: Must specify the [WORLD-SAVE]."
  echo
  usage
  exit 2
fi

if [[ ! -d "$MC_DIR/saves/$save" ]]; then
  echo "ERROR: Found no Minecraft world save $save."
  echo
  usage
  exit 3
fi

if [[ $build = true ]]; then
  $SCRIPT_DIR/build.sh
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Couldn't build the packs."
    echo
    usage
    exit 4
  fi
fi

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