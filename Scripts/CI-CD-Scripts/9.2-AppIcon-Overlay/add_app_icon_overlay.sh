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
echo "--------------------------------------------------------------------"
echo "   Adding App icon overlay for environment: $1 "
echo "--------------------------------------------------------------------"
echo ""


#Project Dir
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))
PROJECT_DIR=$(echo "$ROOT_DIR/Source/BreatheMapper")

#App Version
APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)
APP_VERSION=$(echo $APP_VERSION | cut -d "-" -f 1)

#For which environment? This script will add overlay.
ENVIRONMENT=$1

#Add AppIcon Overlay
ruby app_icon_overlay.rb "$PROJECT_DIR" "$APP_VERSION" "$ENVIRONMENT"

exit $?
