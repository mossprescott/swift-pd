#! /bin/bash

set -e

SDK="$HOME/Developer/PlaydateSDK/C_API"
APP="HelloWorld"

touch Source/pdex.bin
pdc Source "$APP"

# Delete Swift sources from the binary:
rm "$APP.pdx"/*.swift

swiftc \
    -import-objc-header swift/Playdate-Bridging-Header.h \
    -I "$SDK" \
    Source/*.swift \
    swift/Playdate.swift \
    -emit-library \
    -o "$APP.pdx/pdex.dylib"
