#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/out

usage() {
  echo "usage: build.sh"
  echo "Builds the datapack and resource pack into $OUT_DIR."
}

combine() {
  if [[ $# -ne 2 ]]; then
    echo "ERROR: Incorrect arguments specified for combine."
    exit 255
  fi
  target=$1
  output=$2
  if [[ ! -d "$SCRIPT_DIR/$target" ]]; then
    echo "ERROR: Failed to find combine target $target."
    exit 255
  fi
  pushd "$SCRIPT_DIR/$target"
  zip -r $output .
  if [[ $? -ne 0 ]] || [[ ! -f "./$output" ]]; then
    echo "ERROR: Failed to combine $target."
    echo
    usage
    popd
    exit 2
  fi
  mv "./$output" "$SCRIPT_DIR/out/"
  popd
}

if [[ $# -ne 0 ]]; then
  echo "ERROR: Unexpected number of arguments."
  echo
  usage
  exit 1
fi

combine data_pack isomorphic_data.zip
combine resource_pack isomorphic_resc.zip

echo "Build Successful!"
echo 