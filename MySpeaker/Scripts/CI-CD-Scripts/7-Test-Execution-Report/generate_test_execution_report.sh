#!/bin/sh -e


echo ""
echo "-------------------------------------------------------------"
echo "   Generate BreatheMapper iOS Test Execution Report "
echo "-------------------------------------------------------------"
echo ""


# "Run Unit + UI Test-Cases using fastlane."
cd ../6-Run-Test-Cases
sh run_all_test_cases_ios11.sh


# "Generate Test-Cases Execution Report."
cd -
sh test_execution_report_ios11.sh
