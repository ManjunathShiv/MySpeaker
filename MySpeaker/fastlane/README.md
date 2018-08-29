fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios ensure_xcode_version_for_release
```
fastlane ios ensure_xcode_version_for_release
```
This lane will run before execution of other lane.

This lane will ensure that current Xcode version is selected for BreatheMapper project.
### ios ensure_git_branch_for_alpha_release
```
fastlane ios ensure_git_branch_for_alpha_release
```
This lane will ensure that current Git branch BreatheMapper project is develop.
### ios ensure_clean_git_status
```
fastlane ios ensure_clean_git_status
```
This lane will ensure that there is no local changes in BreatheMapper project Git Repo.
### ios run_unit_test_cases
```
fastlane ios run_unit_test_cases
```
This lane will run unit test-cases of BreatheMapper project.
### ios run_ui_test_cases
```
fastlane ios run_ui_test_cases
```
This lane will run UI test-cases of BreatheMapper project.
### ios run_all_test_cases_ios10
```
fastlane ios run_all_test_cases_ios10
```
This lane will run Unit and UI both type test-cases of BreatheMapper project in iOS10 simulator.
### ios run_all_test_cases_ios11
```
fastlane ios run_all_test_cases_ios11
```
This lane will run Unit and UI both type test-cases of BreatheMapper project in iOS11 simulator.
### ios generate_code_coverage_report
```
fastlane ios generate_code_coverage_report
```
This lane will generate code-coverage report of BreatheMapper project.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
