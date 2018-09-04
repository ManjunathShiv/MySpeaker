#!/usr/bin/env ruby

# UpdateServerAttributes.rb
# version 1.0.0
# Contact manish.rathi@philips.com
#
#
# How to Run:
# => ruby 3_update_server_attributes.rb <project_folder_path> <URL> <HMAC_KEY>
#

require "Fastlane"

class UpdateServerAttributes

  def run
    FastlaneCore::UI.header "Step: Inject Url & Hmac-Key in ServerAttributes.swift file"
    #Step1: Find `ServerAttributes.swift` file inside project folder.
    find_server_attributes_swift_file

    #Step2: Update `ServerAttributes.swift` file with input URL & HMAC_KEY.
    update_server_attributes_in_swift_file
  end


  #Step1: Find `ServerAttributes.swift` file inside BreatheMapper project folder.
  def find_server_attributes_swift_file
    project_folder_path = ARGV[0]
    project_folder_path = project_folder_path.strip.gsub('\\','')
    FastlaneCore::UI.important "🔍 Searching ServerAttributes.swift file inside folder: #{project_folder_path}."
    @server_attributes_file_path = Dir["#{project_folder_path}**/**/ServerAttributes.swift"][0]
    FastlaneCore::UI.important "👊 Found ServerAttributes.swift file at path: #{@server_attributes_file_path}."
  end


  #Step2: Update `ServerAttributes.swift` file with input URL & HMAC_KEY.
  def update_server_attributes_in_swift_file
    url = ARGV[1]
    hmac_key = ARGV[2]
    swift_file_content = File.read(@server_attributes_file_path)
    swift_file_content = swift_file_content.gsub(/.*basePath.*/, "\topen static var basePath = \"#{url}\"")
    swift_file_content = swift_file_content.gsub(/.*hmacKey.*/, "\topen static var hmacKey = \"#{hmac_key}\"")

    #Write changes to the ServerAttributes.swift` file.
    File.open(@server_attributes_file_path, "w") do |file|
      file.puts swift_file_content
    end
    FastlaneCore::UI.success "✅ Injected Url & Hmac-Key in ServerAttributes.swift at path: #{@server_attributes_file_path}\n\n"
  end

end


#Start Execution of Script.
UpdateServerAttributes.new.run
