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



echo ""
echo "--------------------------------------------------------------------"
echo "   Setup BretheMapper Project for different environments."
echo "--------------------------------------------------------------------"
echo ""


#Step1: Setup Scripts for different environments.
ruby 2_setup_script_for_environments.rb

#Step2: Create ipa file(s) for different environments. This shell-script file will generate run-time by Build-Machine/Server in Step1.
sh create_ipa_for_environments.sh

exit $?
