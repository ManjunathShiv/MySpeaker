#!/bin/sh -e

# fastlane requires your locale to be set to UTF-8.
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Record Script Execution Time.
record_execution_time(){
  cd ../14-Record-Time
  sh record_execution_time.sh
}

#This Method will terminate the script with error message.
should_exit(){
  if [ $1 != 0 ]
  then
      record_execution_time
      echo "Terminating script with Exit status: $1"
      exit $1
  fi
}


#Step0: "Check that if we need to skip CI."
cd ../../1-Skip-CI
sh should_skip_continuous_integration.sh
if [ $? == 1 ]
then
    exit 0
fi


#Step1: "Record Start Time of Script."
cd ../14-Record-Time
sh record_start_time.sh


#Step2: "Ensure that There is no local changes in Git."
cd ../2-Ensure-Clean-Git-Status
sh ensure_clean_git_status.sh
should_exit $?


#Step3: "Ensure that Current Git branch is develop branch for HockeyApp Upload."
cd ../3-Ensure-Git-Branch
sh ensure_git_branch_for_alpha_release.sh
should_exit $?


#Step4: "Ensure that correct Xcode version is selected."
cd ../4-Ensure-Xcode
sh ensure_xcode_version_for_release.sh
should_exit $?


#Step5: "Bump minor/patch version before uploading to HockeyApp."
cd ../5-Bump-Version
sh bump_version_for_alpha_release.sh $1
should_exit $?


#Step6: "Run Unit + UI Test-Cases using fastlane in iOS10 simulator."
cd ../6-Run-Test-Cases
sh run_all_test_cases_ios10.sh
should_exit $?

#"Generate Test-Cases Execution Report."
cd ../7-Test-Execution-Report
sh test_execution_report_ios10.sh
should_exit $?

#"Run Unit + UI Test-Cases using fastlane in iOS11 simulator."
cd ../6-Run-Test-Cases
sh run_all_test_cases_ios11.sh
should_exit $?


#Step7: "Generate Test-Cases Execution Report."
cd ../7-Test-Execution-Report
sh test_execution_report_ios11.sh
should_exit $?


#Step8: "Generate code coverage report using fastlane."
cd ../8-Code-Coverage
sh generate_code_coverage.sh
should_exit $?


#Step9: "Build project & create .ipa using fastlane."
cd ../9-Create-Ipa
sh 1_build_and_create_ipa_for_alpha_release.sh
should_exit $?


#Step10: "Upload newly generated .ipa file to HockeyApp."
cd ../10-HockeyApp-Upload
sh hockeyapp_alpha_build_upload.sh
should_exit $?


#Step11: "Add Git Tag for HockeyApp Alpha Release."
cd ../11-Add-Git-Tag
sh add_git_tag_for_alpha_release.sh
should_exit $?


#Step12: "Generate HockeyApp Changelog in HTML format."
cd ../12-Release-Notes
sh generate_hockeyapp_html_changelog.sh
should_exit $?


#Step13: "Git commit ipa file of Alpha Release."
cd ../13-Git-Commit-Ipa
sh git_commit_ipa_for_alpha_release.sh
should_exit $?


#Step14: "Record Script Execution Time."
cd ../14-Record-Time
sh record_execution_time.sh
should_exit $?


#Step15: "Git commit Reports for Alpha Release."
cd ../15-Git-Commit-Reports
sh git_commit_reports_for_alpha_release.sh
should_exit $?


#Step16: "Email Notification."
cd ../16-Email-Notification
sh hockeyapp_alpha_release_email_notification.sh
should_exit $?


#Step17: "Slack Notification."
cd ../17-Slack-Notification
sh post_slack_message.sh "BreatheMapper new Version is avaliable on HockeyApp."
should_exit $?
