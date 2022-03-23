#! /bin/bash

set -e

SDK="$HOME/Developer/PlaydateSDK/C_API"
APP="HelloWorld"

touch Source/pdex.bin
pdc Source "$APP"

swiftc \
    -import-objc-header swift/Playdate-Bridging-Header.h \
    -I "$SDK" \
    Source/main.swift \
    swift/Playdate.swift \
    -emit-module \
    -emit-library \
    -o "$APP.pdx/pdex.dylib"
