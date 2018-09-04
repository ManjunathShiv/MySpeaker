#!/usr/bin/env ruby

#  ResourceFileInjector.rb
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
#@brief Copy-Paste Newly created Resource files inside iOS/Android project.
#@details
#1. Script will copy all resource files created by `LocalizationConverter.rb`.
#2. Script will paste all resource files into a particular location/folder inside iOS/Android project based on configuration.
#3. Script will Copy-Paste all .strings resource files in case of iOS localization.
#4. Script will Copy-Paste all .xml resource files in case of Android localization.
#5. Script will perform clean-up after copy-paste opreation.
#
#
#
#@Dependency:
# Script `ResourceFileInjector.rb` has dirent dependency on `ConfigurationReader.rb` file.
# => `ConfigurationReader.rb` read "LocalizationConfiguration.yml" file & provide input to `ResourceFileInjector.rb`
# Script `ResourceFileInjector.rb` has dependency on `fileutils` ruby gem.
# => `fileutils` ruby gem used for copy/paste/remove files operations.
#
#
#
#@How to Use:
#This script can be run by using command: ruby ResourceFileInjector.rb
#@Important:
#This script also accept one optional "LocalizationConfiguration.yml" file-path param.
# i.e ruby ResourceFileInjector.rb       -script will search "LocalizationConfiguration.yml" in current git repository.
# i.e ruby ResourceFileInjector.rb <Path of LocalizationConfiguration.yml file>     -script will use path, given inside param.
#
#
#
#
#
#
#Please contact Manish Rathi - manish.rathi@philips.com for any assistance. Happy Coding 😊💪
#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠


require_relative 'ConfigurationReader.rb'
require 'fileutils'


class ResourceFileInjector
  attr_accessor :configurationReader, :outputFolderPath, :projectFolderPath

  def initialize
    @configurationReader = ConfigurationReader.new
    config_file_path = ARGV[0]
    if config_file_path != nil && config_file_path.strip.length > 1
      @configurationReader.configurationFilePath = config_file_path
    end
    @outputFolderPath = @configurationReader.get_output_folder
    @projectFolderPath = @configurationReader.get_project_resource_folder_path
  end

  def start
    inject_resource_files
    clean_up_resource_files
  end

  def inject_resource_files
    FileUtils.mkdir_p(@outputFolderPath)
    FileUtils.cp_r(Dir[@outputFolderPath + '/.'], @projectFolderPath)
  end

  def clean_up_resource_files
    FileUtils.rm_r(File.dirname(@outputFolderPath))
  end

end



ResourceFileInjector.new.start
