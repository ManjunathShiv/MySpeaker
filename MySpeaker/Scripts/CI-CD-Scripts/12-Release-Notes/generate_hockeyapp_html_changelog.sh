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
echo "--------------------------------------------------"
echo "   Generate BreatheMapper HTML ChangeLog "
echo "--------------------------------------------------"
echo ""

#Root Dir:
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#CHANGELOG File path:
CHANGE_LOG_FILE_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper/CHANGELOG.md")

#Call Ruby Script:
ruby generate_hockeyapp_html_changelog.rb $CHANGE_LOG_FILE_PATH
exit $?
