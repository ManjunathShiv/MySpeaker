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
echo "----------------------------------------------------------"
echo "   Generate BreatheMapper Test-Cases Execution Report"
echo "----------------------------------------------------------"
echo ""

ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))
TEST_CASES_RESULT_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper/fastlane/test_output/report.junit")
TEST_CASES_IMPLEMENTATION_ROOT_FOLDER_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper")

APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)
SIMULATOR_iOS11_INFO=`cat $ROOT_DIR/Source/BreatheMapper/fastlane/iOS11_simulator.txt`
ruby test_execution_report.rb "$TEST_CASES_RESULT_PATH" "$TEST_CASES_IMPLEMENTATION_ROOT_FOLDER_PATH" "$APP_VERSION" "$SIMULATOR_iOS11_INFO"
exit $?
