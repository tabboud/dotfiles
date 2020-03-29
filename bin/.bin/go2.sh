#!/usr/bin/env bash
# This sets up the go2 path so we can work on multiple go projects at the same time.
# Inspired by: https://wiki.crdb.io/wiki/spaces/CRDB/pages/73138403/Multiple+GOPATHs

BASE="/Volumes/git/go2"

# remove the original $GOPATH/BIN if it's there
if [ -n "$GOPATH" ]; then
    PATH=$(echo "$PATH" | sed "s#:$GOPATH/bin##g")
fi

echo "Setting GOPATH to $BASE"
export GOPATH=$BASE
export PATH=$GOPATH/bin:$PATH
echo "Path updated to $PATH"
