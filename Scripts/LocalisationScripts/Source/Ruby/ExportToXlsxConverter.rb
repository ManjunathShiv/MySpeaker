#!/usr/bin/env ruby

# A light weight Export To Xlsx converter, which convert .strings/.xml files into .xlsx file.
# Contact manish.rathi@philips.com

require 'rubyXL'
require_relative 'ConfigurationReader.rb'


#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Language Class ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class Language
  attr_accessor :name, :values
  def initialize
    @values = Hash.new
    @values.default = ""
  end
end


#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Export To Xlsx Converter ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class ExportToXlsxConverter
  attr_accessor :languages, :keys, :configurationReader
  def initialize
    @languages = Hash.new
    @keys = []
    @configurationReader = ConfigurationReader.new
    config_file_path = ARGV[0]
    if config_file_path != nil && config_file_path.strip.length > 1
      @configurationReader.configurationFilePath = config_file_path
    end
  end


  def start
    parse_resource_files
    create_excel_file(@configurationReader.get_excel_folder_path_for_export)
  end


  def parse_resource_files
    parse_iOS_files(@configurationReader.get_iOS_project_resource_folder_path)
    parse_android_files(@configurationReader.get_android_project_resource_folder_path)
  end

  def parse_iOS_files(resource_folder_path)
    Dir.glob("#{resource_folder_path}/**/*.lproj") { |iOS_string_file_path|
      language = Language.new
      language.name = File.basename("#{iOS_string_file_path}", ".lproj")
      File.foreach("#{iOS_string_file_path}/Localizable.strings") do |line|
        lineText = line.strip
        if lineText.length < 1 || lineText[0,2] == "/*" || lineText[0,2] == "//"
          next
        end
        lineText = lineText.gsub('";',"")
        lineKeyValuePair = lineText.split("=")
        key = lineKeyValuePair[0].gsub('"',"").strip
        value = lineKeyValuePair[1].strip[1..-1].strip
        language.values[key] = value
        if (@keys.include? key) == false
          @keys << key
        end
      end
        @languages[language.name] = language
    }
  end

  def parse_android_files(resource_folder_path)
    Dir.glob("#{resource_folder_path}/**/strings.xml") { |android_xml_file_path|
      language_name = (File.basename(File.dirname("#{android_xml_file_path}"))).split("values-")[1]
      language = @languages[language_name]
      if language == nil
        language = Language.new
        language.name = language_name
        @languages[language.name] = language
      end
      File.foreach("#{android_xml_file_path}") do |line|
        lineText = line.strip
        if lineText.length > 1 && lineText[0,13] == "<string name=" && ((lineText.include? "translatable") == false)
          lineText = lineText.gsub('<string name="',"")
          lineText = lineText.split('</string>')[0].to_s.gsub("</string>","")
        else
          next
        end
        lineKeyValuePair = lineText.split('">')
        key = lineKeyValuePair[0].strip
        if (@keys.include? key) == false
          value = lineKeyValuePair[1].strip
          language.values[key] = value
          @keys << key
        end
      end
    }
  end


  def create_excel_file(folder_path)
    xlsx_file_path = "#{folder_path}"
    xlsx_file_name = "localization#{Time.new}.xlsx"
    xlsx_file = RubyXL::Workbook.new
    insert_keys_details(xlsx_file.worksheets[0])
    insert_languages_details(xlsx_file.worksheets[0])
    xlsx_file.write("#{xlsx_file_path}/#{xlsx_file_name}")
  end


  def insert_keys_details(sheet)
    @keys.each_with_index do |key, index|
      sheet.add_cell(index, 0, key)
    end
  end

  def insert_languages_details(sheet)
    column_index = 0
    @languages.each do |key, language|
      if key.casecmp?("Key") == false
        column_index += 1
        @keys.each_with_index do |key, index|
          sheet.add_cell(index, column_index, language.values[key])
        end
      end
    end
  end

end


ExportToXlsxConverter.new.start
