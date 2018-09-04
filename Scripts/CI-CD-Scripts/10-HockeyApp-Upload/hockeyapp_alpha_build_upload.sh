#!/bin/sh -e


# Check If we need to skip CI
cd ../1-Skip-CI
sh should_skip_continuous_integration.sh
if [ $? == 1 ]
  then
    exit 0
  else
    cd -
fi


echo ""
echo "----------------------------------------------------------------"
echo "   Upload BreatheMapper Alpha build ipa file to HockeyApp"
echo "----------------------------------------------------------------"
echo ""

#Root Dir:
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#App Version
APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)

#For which environment? This script will upload ipa to HockeyApp.
ENVIRONMENT="avengers"

#IPA File Path:
IPA_FILE_PATH=$(echo "$(find $ROOT_DIR/Source/BreatheMapper/Binaries/$APP_VERSION/$ENVIRONMENT -name "*.ipa")")

#Release notes:
RELEASE_NOTES_FILE_PATH="$ROOT_DIR/Source/BreatheMapper/CHANGELOG.md"
NOTES=$(cat $RELEASE_NOTES_FILE_PATH)


echo "\n\n"
echo "🚗 Start Uploading ipa file to HockeyApp with Info:"
echo "🔖 App-Version: $APP_VERSION"
echo "📌 Environment: $ENVIRONMENT"
echo "🔗 iPa file-path: $IPA_FILE_PATH"
echo "🔗 Release-Notes file-path: $RELEASE_NOTES_FILE_PATH"
echo "\n\n"


#Curl command to upload build to Hockeyapp:
curl -x http://165.225.104.34:9480/ -v --connect-timeout 30 -F "status=2" -F "ipa=@$IPA_FILE_PATH" -F "notify=2" -F "notes_type=1" -F "notes=$NOTES" -H "X-hockeyApptoken: b882c7300e8e45e5929d157266e16613" https://rink.hockeyapp.net/api/2/apps/c2351eb94ffb412ca595bd3d3e41dca2/app_versions/upload
exit $?
