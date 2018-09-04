#!/bin/sh



echo ""
echo "-------------------------------------------------------------------"
echo "   Post Slack Notification for HockeyApp Alpha Release. "
echo "-------------------------------------------------------------------"
echo ""

APP_VERSION=$(sh ../5.1-Get-Version/get_version_string.sh)

SLACK_MESSAGE="A new *BreatheMapper iOS Alpha build version: $APP_VERSION* is available to download from the HockeyApp.\n<https://rink.hockeyapp.net/manage/apps/775901>"

SLACK_ATTACHMENTS="[ \
      { \
          \"color\": \"#36a64f\", \
          \"title\": \"iOS10 Test Execution Report\", \
          \"title_link\": \"https://scm.sapphirepri.com/Mapper/BreatheMapperIos/blob/develop/Source/BreatheMapper/fastlane/reports/iOS10-TestExecutionReport.html\", \
          \"text\": \"BreatheMapper iOS10 Test Execution Report.\" \
      }, \
      { \
          \"color\": \"#36a64f\", \
          \"title\": \"iOS11 Test Execution Report\", \
          \"title_link\": \"https://scm.sapphirepri.com/Mapper/BreatheMapperIos/blob/develop/Source/BreatheMapper/fastlane/reports/iOS11-TestExecutionReport.html\", \
          \"text\": \"BreatheMapper iOS11 Test Execution Report.\" \
      }, \
      { \
      \"color\": \"#36a64f\", \
      \"title\": \"Release Notes\", \
      \"title_link\": \"https://scm.sapphirepri.com/Mapper/BreatheMapperIos/blob/develop/Source/BreatheMapper/fastlane/reports/Changelog.html\", \
      \"text\": \"BreatheMapper iOS Release Notes.\" \
      } \
  ]"



sh 0_post_slack_message.sh "$SLACK_MESSAGE" "$SLACK_ATTACHMENTS"
exit $?
