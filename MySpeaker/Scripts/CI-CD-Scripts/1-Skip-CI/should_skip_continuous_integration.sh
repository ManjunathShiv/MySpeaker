#!/bin/sh -e

echo ""
echo "--------------------------------------------------------------------"
echo "   Checking If CI need to be Skip for current commit"
echo "--------------------------------------------------------------------"
echo ""

FILE_NAME=".skip_ci.txt"
shouldSkip="true"

if [ -f "$FILE_NAME" ]
then
	shouldSkip=`cat $FILE_NAME`
fi


if [[ $shouldSkip == "true" ]]
then
  echo "🚫 [skip ci] Or [ci skip] has been found in Git log, so will skip CI."
  exit 1
else
  echo "✅  [skip ci] Or [ci skip] not found in Git log, so CI will continue."
  exit 0
fi
