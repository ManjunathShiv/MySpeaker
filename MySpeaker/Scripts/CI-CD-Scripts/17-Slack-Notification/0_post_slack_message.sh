#!/bin/sh


# Check If we need to skip CI
cd ../1-Skip-CI
sh should_skip_continuous_integration.sh
if [ $? == 1 ]
  then
    exit 0
  else
    cd -
fi


function post_to_slack () {
  SLACK_MESSAGE=$1
  SLACK_ATTACHMENTS=$2
  SLACK_URL="https://hooks.slack.com/services/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"
  USER_NAME="BM iOS CI/CD"
  CHANNEL="team-stack"

  case "$3" in
    INFO)
      SLACK_ICON='good'
      ;;
    WARNING)
      SLACK_ICON='warning'
      ;;
    ERROR)
      SLACK_ICON='danger'
      ;;
    *)
      SLACK_ICON='good'
      ;;
  esac

  if [ -z "$SLACK_ATTACHMENTS" ]
  then
        SLACK_ATTACHMENTS="[]"
  fi

  PAYLOAD="{\"channel\":\"$CHANNEL\", \
    \"username\":\"$USER_NAME\", \
    \"icon_emoji\":\"ghost\", \
    \"text\": \"$SLACK_MESSAGE\", \
    \"attachments\": $SLACK_ATTACHMENTS \
  }"

  curl -x http://165.225.104.34:9480/ -v --connect-timeout 30 POST --data "payload=$PAYLOAD" ${SLACK_URL}
}

post_to_slack "$1" "$2" "$3"

exit $?
