#!/usr/bin/env ruby

#  ConfigurationReader.rb
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
#@brief Read "LocalizationConfiguration.yml" file.
#@details
#1. Script will search for "LocalizationConfiguration.yml" file inside current Git repository.
#2. Script will read "LocalizationConfiguration.yml" file.
#3. Script provides useful APIs, which is used inside `LocalizationConverter.rb` & `ResourceFileInjector.rb`.
#
#
#
#@Dependency: => N/A
#
#
#
#@How to Use:
# => No Direct Use
#@Important:
# => Script provides useful APIs, which is used inside `LocalizationConverter.rb` & `ResourceFileInjector.rb`.
#
#
#
#
#
#
#Please contact Manish Rathi - manish.rathi@philips.com for any assistance. Happy Coding 😊💪
#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠


class ConfigurationReader

  attr_accessor :configurationFileName, :configurationFilePath,
                :excelFilePathKey, :platformKey, :resourceFolderPathKey

  def initialize
    # Import Configuration Keys
    @configurationFileName = "LocalizationConfiguration.yml"
    @excelFilePathKey = "excel_file_path"
    @platformKey = "platform"
    @resourceFolderPathKey = "project_resource_folder_path"

    #Find Localization Configuration.yml file path
    gitRepoRootPath = find_git_repo
    @configurationFilePath = Dir["#{gitRepoRootPath}/**/#{@configurationFileName}"][0]
  end


  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Parse Configuration File ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def parse_config_file_for_key(key)
    File.foreach("#{@configurationFilePath}") do |line|
      lineText = line.strip
      if lineText.length > 1 && (lineText.include? "#{key}")
        lineText = lineText.gsub('"',"")
        lineText = lineText.split(':')[1].to_s.strip
        lineText = lineText.gsub('\\','')
        return lineText
      else
        next
      end
    end
    return ""
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Import Configurations ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠

  #Return Excel File Path
  def get_excel_sheet_file_path
    excelFilePath = parse_config_file_for_key(@excelFilePathKey)
    return File.expand_path("#{excelFilePath}", "#{File.dirname(@configurationFilePath)}")
  end


  #Return iOS Resource Folder Path
  def get_project_resource_folder_path
    resourceFilePath = parse_config_file_for_key(@resourceFolderPathKey)
    return File.expand_path("#{resourceFilePath}", "#{File.dirname(@configurationFilePath)}")
  end

  #Return true, If we need to perform localization for iOS
  def should_perform_localization_for_iOS
    supportedPlatforms = parse_config_file_for_key(@platformKey)
    return (supportedPlatforms.downcase.include? "ios")
  end

  #Return true, If we need to perform localization for android
  def should_perform_localization_for_android
    supportedPlatforms = parse_config_file_for_key(@platformKey)
    return (supportedPlatforms.downcase.include? "android")
  end

  #Return output folder Path
  def get_output_folder
    if should_perform_localization_for_iOS
      return get_iOS_output_folder
    end
    return get_android_output_folder
  end

  #Return android output folder Path
  def get_android_output_folder
    return "../output/android/"
  end

  #Return iOS output folder Path
  def get_iOS_output_folder
    return "../output/iOS/"
  end


  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Find the current git repository Root ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  # Returns the git root directory given a path inside the repo. Returns nil if
  # the path is not in a git repo.
  def find_git_repo(start_path = '.')
    raise NoSuchPathError unless File.exists?(start_path)

    current_path = File.expand_path(start_path)
    return_path = nil

    until root_directory?(current_path)
      if File.exists?(File.join(current_path, '.git/HEAD'))
        return_path = current_path # done
        break
      else
        current_path = File.dirname(current_path) # go up a directory and try again
      end
    end
    return_path
  end

  # Returns true if the given path represents a root directory.
  def root_directory?(file_path)
    File.directory?(file_path) &&
      File.expand_path(file_path) == File.expand_path(File.join(file_path, '..'))
  end

end
