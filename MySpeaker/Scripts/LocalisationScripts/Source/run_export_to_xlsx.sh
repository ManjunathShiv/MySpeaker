#!/bin/sh

#  run_export_to_xlsx.sh
#
#  Created by Manish Rathi
#
#
# Copyright (c) Koninklijke Philips N.V., 2018
# All rights are reserved. Reproduction or dissemination
# in whole or in part is prohibited without the prior written
# consent of the copyright holder.


#Go to Ruby Script Folder.
cd Ruby


#Check If User has provided params for LocalizationConfiguration.yml file path or not.
if [ "$1" ]
then
    # Coverterting Localization details from iOS/Android resource(.strings/.xml) files into Excel(.xlsx) file."
  ruby ExportToXlsxConverter.rb $1
else
  # Coverterting Localization details from iOS/Android resource(.strings/.xml) files into Excel(.xlsx) file."
  ruby ExportToXlsxConverter.rb
fi #End of IF-Else
