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
echo "   Generate Email Notification body from template. "
echo "--------------------------------------------------"
echo ""

APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)

ruby hockeyapp_alpha_release_email_notification.rb $APP_VERSION
exit $?
