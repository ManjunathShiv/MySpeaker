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
### ios basic
```
fastlane ios basic
```

### ios test1
```
fastlane ios test1
```

### ios test2
```
fastlane ios test2
```

### ios test3
```
fastlane ios test3
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
