#!/bin/sh -e


# "Release HockeyApp Alpha build with patch version bumping."
sh 0_hockeyapp_alpha_release_steps.sh "patch"
exit $?
