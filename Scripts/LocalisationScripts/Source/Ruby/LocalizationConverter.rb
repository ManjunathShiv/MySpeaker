#!/usr/bin/env ruby

#  LocalizationConverter.rb
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
#@brief A light weight localization converter, which convert .xlsx file into .strings/.xml file.
#@details
#1. Script will parse .xlsx file, which contains Localization details for each country in columns.
#2. Script will create Localization resource files for iOS/Android based on configuration.
#3. Script will create .strings resource files in case of iOS localization.
#4. Script will create .xml resource files in case of Android localization.
#5. Script will add default header inside each iOS/Android resource files.
#
#
#
#@Dependency:
# Script `LocalizationConverter.rb` has dirent dependency on `ConfigurationReader.rb` file.
# => `ConfigurationReader.rb` read "LocalizationConfiguration.yml" file & provide input to `LocalizationConverter.rb`
# Script `LocalizationConverter.rb` has dependency on `rubyXL` ruby gem.
# => `rubyXL` ruby gem used to read .xlsx file.
#
#
#
#@How to Use:
#This script can be run by using command: ruby LocalizationConverter.rb
#@Important:
#This script also accept one optional "LocalizationConfiguration.yml" file-path param.
# i.e ruby LocalizationConverter.rb       -script will search "LocalizationConfiguration.yml" in current git repository.
# i.e ruby LocalizationConverter.rb <Path of LocalizationConfiguration.yml file>     -script will use path, given inside param.
#
#
#
#
#
#
#Please contact Manish Rathi - manish.rathi@philips.com for any assistance. Happy Coding 😊💪
#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠


require 'os'
require 'rubyXL'
require 'fileutils'
require_relative 'ConfigurationReader.rb'


#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Language Class ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class Language
  attr_accessor :name, :values

  def initialize
    @values = Hash.new
  end

end


#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Localization Converter ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class LocalizationConverter
  attr_accessor :languages, :configurationReader, :replacementMapAndroid, :replacementMapIos, :userName

  def initialize
    @languages = Hash.new
    @configurationReader = ConfigurationReader.new
    config_file_path = ARGV[0]
    if config_file_path != nil && config_file_path.strip.length > 1
      @configurationReader.configurationFilePath = config_file_path
    end
    if OS.windows? == true
      @userName = ENV["USERNAME"]
    else
      @userName = ENV["USER"]
    end
    @replacementMapAndroid = {
                                "&" => "&amp;",
                                "<" => "&lt;",
                                ">" => "&gt;",
								                "-" => "&#8211;",
                                "\"" => "\&quot;",
                                "“" => "\&quot;",
                                "”" => "\&quot;",
                                "'" => "’",
                                "%@" => "%s",
                                /\u00a0/ => " "
                                }
    @replacementMapIos = {
                            "\"" => "\\\"",
                            "%s" => "%@",
                            /\u00a0/ => " "
                          }
  end


  def start
    parse_excel_file
    create_resource_files
  end


  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Parse Excel .xlsx file ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def parse_excel_file
    xlsx_file_path = @configurationReader.get_excel_sheet_file_path
    xlsx_file = RubyXL::Parser.parse("#{xlsx_file_path}")
    xlsx_file_sheet = xlsx_file.worksheets[0]
    parse_excel_file_sheet(xlsx_file_sheet)
  end

  def parse_excel_file_sheet(sheet)
    sheet.each { |row|
      cellIndex = 0
       row && row.cells.each { |cell|
         cellValue = cell && cell.value
         if cellValue != nil
           cellValue = cellValue.to_s.strip
           language_name = sheet[0][cellIndex].value.to_s.strip
           language = @languages[language_name]
           if language == nil
             language = Language.new
             language.name = language_name
             @languages[language.name] = language
           end
           key = row.cells[0].value.to_s.strip
           language.values[key] = cellValue
         end
         cellIndex += 1
       }
    }
  end


  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Create iOS & Android resource files ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def create_resource_files
    @languages.each do |key, language|
      if @configurationReader.should_perform_localization_for_iOS && key.downcase != 'key' && key.downcase != 'comments'
        Thread.new{create_ios_file(language)}.join
      end

      if @configurationReader.should_perform_localization_for_android  && key.downcase != 'key' && key.downcase != 'comments'
        Thread.new{create_android_file(language)}.join
      end
    end
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Create Android xml resource file ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def create_android_file(language)
    file_path = get_file_path(language.name, :android)
    open(file_path, 'w+') do |file|
          print_android_xml_file_header(file, language)
          language.values.each do |key, value|
            file.puts "    <string name=\"%{name}\">%{value}</string>" % {:name => key, :value => format_android_string(value)}
          end
      file.puts "</resources>"
    end
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Create iOS .strings resource file ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def create_ios_file(language)
    file_path = get_file_path(language.name, :ios)
    open(file_path, 'w+') do |file|
          print_ios_strings_file_header(file, language)
          language.values.each do |key, value|
            file.puts "\"%{name}\" = \"%{value}\";" % {:name => key, :value => format_ios_string(value)}
      end
    end
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Setup File Path ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def get_file_path(name, config)
    file_path = ''
    if config == :ios
      file_path = "#{@configurationReader.get_iOS_output_folder}" + name + ".lproj" + "/Localizable.strings"
    else
        if name == "en"
            file_path = "#{@configurationReader.get_android_output_folder}" + "values" + "/strings.xml"
        else
            file_path = "#{@configurationReader.get_android_output_folder}" + "values-"+ name + "/strings.xml"
        end
    end
    dir = File.dirname(file_path)
    unless File.directory?(file_path)
        FileUtils.mkdir_p(dir)
    end
    file_path
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Android xml resource file Header ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def print_android_xml_file_header(file, language)
    file.puts "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    file.puts "<!-- © Koninklijke Philips N.V., #{DateTime.now.strftime '%Y'}. All rights reserved. -->\n\n"
    file.puts "<!-- ####################################################################### -->"
    file.puts "<!--  Important Notice:📌 -->\n                                                "
    file.puts "<!--  This file is auto-generated from localization excel file. -->            "
    file.puts "<!--  Do not edit this file directly. -->                                      "
    file.puts "<!--  Created by:👇 -->                                                        "
    file.puts "<!--  User: #{@userName} -->                                                 "
    file.puts "<!--  Date Time: #{Time.new} -->                                               "
    file.puts "<!-- ####################################################################### -->"
    file.puts "\n\n\n\n"
    file.puts "<resources>\n"
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ iOS .strings resource file Header ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def print_ios_strings_file_header(file, language)
    file.puts "// © Koninklijke Philips N.V., #{DateTime.now.strftime '%Y'}. All rights reserved.\n\n"
    file.puts "// +-------------------------------------------------------------------+"
    file.puts "//  Important Notice:📌\n                                                "
    file.puts "//  This file is auto-generated from localization excel file.            "
    file.puts "//  Do not edit this file directly.                                      "
    file.puts "//  Created by:👇                                                        "
    file.puts "//  User: #{@userName}                                                 "
    file.puts "//  Date Time: #{Time.new}.                                              "
    file.puts "// +--------------------------------------------------------------------+"
    file.puts "\n\n\n\n"
  end

  #≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Format Strings ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
  def format_android_string(value)
      @replacementMapAndroid.each do |k, v|
        value.gsub!(k, v) rescue ""
      end
        value
      value
  end

  def format_ios_string(value)
      @replacementMapIos.each do |k, v|
        value.gsub!(k, v) rescue ""
      end
        value
      value
  end

end


LocalizationConverter.new.start
