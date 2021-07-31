#!/usr/bin/env bash

HOME_DIR="$(dirname $(readlink -f $0))"
BUILD_DIR="$HOME_DIR/build"
SCRIPT_DIR="$HOME_DIR/scripts"
ORADATA="$HOME_DIR/oradata"
EXTRA="$HOME_DIR/extra"

for i in "$SCRIPT_DIR" "$ORADATA" "$BUILD_DIR"; do 
  [[ -d "$i" ]] || { 
    echo 1>&2 "ERROR: $SCRIPT_DIR does not exist"
    exit 1
  }
done

chmod 777 "$ORADATA"

docker build --network=host -t csci6441/oracle:1.0 "$BUILD_DIR"

docker run --rm -d --name oracle \
  -p 1521:1521 \
  -e ORACLE_SID=csci6441 \
  -e ORACLE_PWD=password \
  -e ORACLE_PDB=pp \
  -e INIT_PGA_SIZE=1024 \
  -e INIT_SGA_SIZE=6144 \
  -v $SCRIPT_DIR:/opt/oracle/scripts/setup \
  -v $ORADATA:/opt/oracle/oradata \
  -v $EXTRA:/home/oracle/extra \
  csci6441/oracle:1.0
