#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build
SERVER_DIR=$SCRIPT_DIR/server

echo "$SERVER_DIR"
pushd $OUT_DIR
ls | xargs rm -rf
popd
pushd $SERVER_DIR
ls | xargs rm -rf
popd