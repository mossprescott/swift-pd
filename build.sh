#! /bin/bash

# Run this from the directory where your game's Package.swift lives:
#
# $ cd Examples/HelloWorld
# $ ../../build.sh
# $ open HelloWorld.pdx

set -e

ROOT=$(dirname $0)
SDK="$HOME/Developer/PlaydateSDK/C_API"
BUILD_DIR=.build/arm64-apple-macosx/debug
APP_NAME=$(swift package describe | head -1 | cut -w -f 2)

# Hackishly copy the API headers into the library's source dir because I don't know to get SPM
# to refer to them from the include path:
cp -r "$SDK"/pd_api* $ROOT/swift/Sources/CPlaydate/

# Compile and link the game (and the Playdate library along with it):
swift build

# Run pdc to convert/assemble any required assets:
touch Sources/Resources/pdex.bin
pdc Sources/Resources "$APP_NAME"
rm Sources/Resources/pdex.bin
rm "${APP_NAME}.pdx/pdex.bin"

# Copy the game library into place:
cp "${BUILD_DIR}/lib${APP_NAME}.dylib" "${APP_NAME}.pdx/pdex.dylib"

ls -l "${APP_NAME}.pdx"
