#!/bin/sh -e


#How to use:
#
# APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)
#


#Root Dir:
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#Plist File Path:
PLIST_FILE_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper/BreatheMapper/SupportFiles/Info.plist")


#App Version:
APP_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_FILE_PATH")
echo "$APP_VERSION"

exit 0
