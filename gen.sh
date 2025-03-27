#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR=$SCRIPT_DIR/build
SERVER_DIR=$SCRIPT_DIR/server
SERVER_JAR=$SCRIPT_DIR/server.jar

if [[ ! -f "$SERVER_JAR" ]]; then
  echo "ERROR: Didn't find server.jar $SERVER_JAR"
  echo "Please download manually at https://www.minecraft.net/en-us/download/server."
  echo
  exit 1
fi

if [[ ! -d "$SERVER_DIR" ]]; then
  mkdir "$SERVER_DIR"
fi

if [[ ! -f "$SERVER_DIR/server.jar" ]]; then
  cp -f "$SERVER_JAR" "$SERVER_DIR/server.jar"
fi

pushd "$SERVER_DIR"
# This is the minecraft data generator https://minecraft.wiki/w/Tutorial:Running_the_data_generator
java -DbundlerMainClass=net.minecraft.data.Main -jar server.jar --reports 
if [[ $? -ne 0 ]]; then 
  echo "ERROR: Failed to generate the reports via the data generator."
  echo
  popd
  exit 2
fi
java -DbundlerMainClass=net.minecraft.data.Main -jar server.jar --server 
if [[ $? -ne 0 ]]; then 
  echo "ERROR: Failed to generate the data via the data generator."
  echo
  popd
  exit 2
fi
popd

echo "Generate Successful!"
echo 