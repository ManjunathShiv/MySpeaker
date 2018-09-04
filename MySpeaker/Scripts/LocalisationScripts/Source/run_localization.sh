#!/bin/sh

#  run_localization.sh
#
#  Created by Manish Rathi
#
#
# Copyright (c) Koninklijke Philips N.V., 2018
# All rights are reserved. Reproduction or dissemination
# in whole or in part is prohibited without the prior written
# consent of the copyright holder.



#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
#Version 1.0.0
#@brief Perform Localization.
#@details
#1. Covertert Localization details from Excel(.xlsx) file into iOS/Android resource(.strings/.xml) files.
#2. Inject newly generated iOS/Android resource(.strings/.xml) files inside iOS/Android project.
#
#
#
#@How to Use:
#This script can be run by using command: sh run_localization.sh
#@Important:
#This script also accept one optional "LocalizationConfiguration.yml" file-path param, which used inside Ruby Scripts.
# i.e sh run_localization.sh  OR
# i.e sh run_localization.sh <Path of LocalizationConfiguration.yml file>
#
#
#
#
#
#
#Please contact Manish Rathi - manish.rathi@philips.com for any assistance. Happy Coding 😊💪
#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠




#Go to Ruby Script Folder.
cd Ruby


#Check If User has provided params or not, for LocalizationConfiguration.yml.
if [ "$1" ]
then
  ruby LocalizationConverter.rb $1
  ruby ResourceFileInjector.rb $1
else
  ruby LocalizationConverter.rb
  ruby ResourceFileInjector.rb
fi
