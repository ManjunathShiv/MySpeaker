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
echo "   Record Start Time of CI/CD Scripts "
echo "--------------------------------------------------"
echo ""

# Record Start Time of Script.
SCRIPT_EXECUTION_START_TIME=$(echo $(date +"%Y-%m-%d %T %z"))

ruby record_start_time.rb $SCRIPT_EXECUTION_START_TIME
exit $?
