#!/bin/sh -e


echo ""
echo "--------------------------------------------------------------------"
echo "                Generate CRC32 file for .ipa file path: $1"
echo "--------------------------------------------------------------------"
echo ""


#ipa local file path
IPA_FILE_PATH=$1
BUILD_NAME="$(basename $IPA_FILE_PATH)"
IPA_CREATED_DATE="$(date -r $IPA_FILE_PATH)"

#Genrate CRC number
CRC32="$(crc32 $IPA_FILE_PATH)"
echo "CRC number for build $BUILD_NAME is: $CRC32"

#Create CRC File
CRC32_FILE_PATH="$(dirname $IPA_FILE_PATH)/CRC32.txt"
touch $CRC32_FILE_PATH
printf "This file Generated on $(date)\n\r\n\rFile Name: $BUILD_NAME$IPA\n\rCreated Date: $IPA_CREATED_DATE\n\rCRC32: $CRC32" > $CRC32_FILE_PATH

exit $?
