#!/bin/sh -e

# fastlane requires your locale to be set to UTF-8.
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Check If we need to skip CI
cd ../1-Skip-CI
sh should_skip_continuous_integration.sh
if [ $? == 1 ]
  then
    exit 0
  else
    cd -
fi


# Move to project folder.
cd ../../../MySpeaker


echo ""
echo "--------------------------------------------------------------"
echo "   Ensure that correct Xcode version is selected"
echo "--------------------------------------------------------------"
echo ""

fastlane ensure_xcode_version_for_release
exit $?
