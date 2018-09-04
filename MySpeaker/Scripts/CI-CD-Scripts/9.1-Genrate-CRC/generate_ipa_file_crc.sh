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
echo "   Generate CRC32 of .ipa file for environment: $1 "
echo "--------------------------------------------------------------------"
echo ""


#Root Dir
ROOT_DIR=$(dirname $(dirname $(dirname $(pwd))))

#App Version
APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)

#For which environment? This script will create CRC32.
ENVIRONMENT=$1

#IPA File Path:
IPA_FILE_PATH=$(echo "$(find $ROOT_DIR/Source/BreatheMapper/Binaries/$APP_VERSION/$ENVIRONMENT -name "*.ipa")")


#Generate CRC32 File:
sh 0_generate_ipa_file_crc.sh $IPA_FILE_PATH

exit $?
