#!/bin/sh -e

# fastlane requires your locale to be set to UTF-8.
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Move to project folder.
cd ../../MySpeaker


echo ""
echo "--------------------------------------------------------------"
echo "   Ensure that There is no local changes in Git Repository"
echo "--------------------------------------------------------------"
echo ""

fastlane ensure_clean_git_status
exit $?
