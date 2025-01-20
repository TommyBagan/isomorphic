#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build

usage() {
  echo "usage: overlay.sh [-b] [-w] <WORLD-SAVE>"
  echo "Overlays the datapack and resource pack into Minecraft <WORLD-SAVE>."
  echo
  echo "  -b             Builds before overlaying."
  echo "  -w             Runs assuming a Windows Minecraft install."
}

overlay_output() {
  if [[ $# -ne 1  ]]; then
    echo "ERROR: Incorrect arguments specified for overlay_output."
    echo
    exit 255
  fi
  output=$1

  if [[ ! -f "$OUT_DIR/$output" ]]; then
    echo "ERROR: Couldn't find build output zip $output under $OUT_DIR."
    echo
    usage
    exit 5
  fi

  cp -f "$OUT_DIR/$output" "$MC_DIR/saves/$save/datapacks/"
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to overlay datapack $output."
    echo
    popd
    exit 6
  fi

  cp -f "$OUT_DIR/$output" "$MC_DIR/resourcepacks/"
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to overlay resource pack $output."
    echo
    popd
    exit 7
  fi
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
  $SCRIPT_DIR/build.sh -q
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Couldn't build the packs."
    echo
    usage
    exit 4
  fi
fi

overlay_output IsomorphicCore.zip
overlay_output IsomorphicExtDHA.zip
overlay_output Floristic.zip
overlay_output Prospective.zip

echo "Overlay Successful!"
echo