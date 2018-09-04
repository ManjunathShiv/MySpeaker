#!/bin/sh -e


# "Release HockeyApp Alpha build with minor version bumping."
sh 0_hockeyapp_alpha_release_steps.sh "minor"
exit $?
