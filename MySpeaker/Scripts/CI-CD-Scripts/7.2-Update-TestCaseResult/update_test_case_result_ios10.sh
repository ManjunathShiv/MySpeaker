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
echo "   Update BreatheMapper iOS10 Test-Cases Result"
echo "----------------------------------------------------------"
echo ""

#Root Dir:
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#iOS10 JSON File Path:
JSON_FILE_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper/fastlane/reports/iOS10-TestExecutionReport.json")

#Call Ruby Script:
ruby update_test_case_result.rb $JSON_FILE_PATH
exit $?
