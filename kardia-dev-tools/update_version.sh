#!/bin/bash

VERSION=$(git log | grep '^Date:' | wc -l)
RELDATE=$(git log | grep '^Date:' | head -1 | sed 's/^Date:   \(.*\) [0-9][0-9]:[0-9][0-9]:[0-9][0-9] \([0-9][0-9][0-9][0-9]\).*/\1, \2/')
INFO=kardia-app/app_info.struct

if [ -f "$INFO" ]; then
    sed -i 's/^    app_release=".*";$/    app_release="'"$RELDATE"'";/' "$INFO"
    sed -i 's/^    app_version=".*";$/    app_version="'"$VERSION"'";/' "$INFO"
else
    echo "Could not find file $INFO"
fi
