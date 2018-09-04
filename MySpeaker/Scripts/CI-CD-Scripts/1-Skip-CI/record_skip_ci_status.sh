#!/bin/sh -e

echo ""
echo "--------------------------------------------------------------------"
echo "   Determine If CI need to be Skip for current commit"
echo "--------------------------------------------------------------------"
echo ""


LAST_COMMIT_LOG=$(echo $(git log -1))
SKIP_REGX=".*\[skip ci\]|\[ci skip\].*"

shopt -s nocasematch

if [[ $LAST_COMMIT_LOG =~ $SKIP_REGX ]]
then
  echo "🚫 [skip ci] Or [ci skip] has been found in Git log, so will skip CI."
  ruby record_skip_ci_status.rb "true"
else
  echo "✅  [skip ci] Or [ci skip] not found in Git log, so CI will continue."
  ruby record_skip_ci_status.rb "false"
fi

exit $?
