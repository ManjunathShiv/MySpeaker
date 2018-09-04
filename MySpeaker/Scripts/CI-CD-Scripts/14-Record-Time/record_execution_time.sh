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
echo "   Record Execution Time of CI/CD Scripts "
echo "--------------------------------------------------"
echo ""

#Root Dir:
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#DURATION File Path:
SAVE_DURATION_FILE_PATH=$(echo "$ROOT_DIR/Source/BreatheMapper/fastlane/reports/save_duration.txt")

#Call Ruby Script:
ruby record_execution_time.rb $SAVE_DURATION_FILE_PATH
exit $?
