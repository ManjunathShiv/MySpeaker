#!/usr/bin/env ruby

# SetupScriptForEnvironments.rb
# version 1.0.0
# Contact manish.rathi@philips.com
#
#
# How to Run:
# => ruby 2_setup_script_for_environments.rb
#

require "Fastlane"

class SetupScriptForEnvironments

  def run
    FastlaneCore::UI.header "Step: Read EnvironmentProperties & Setup script for creating iPa file(s)"

    #Step1: Read EnvironmentProperties.json file.
    read_environment_properties_json_file

    #Step2: Prepare script-content by using `script_for_environment.mustache` file with EnvironmentProperties.json content.
    prepare_script_content

    #Step3: Generate shell-script file as per `create_ipa_with_environments.mustache` file with Step2 content.
    generate_script_file_for_create_ipa
  end


  #Step1: Read EnvironmentProperties.json file.
  def read_environment_properties_json_file
    json_file_path = "#{ENV['HOME']}/Library/BreatheMapper/EnvironmentProperties.json"
    FastlaneCore::UI.important "📖 Reading Environment Properties from file: #{json_file_path}."
    json_file = File.read(json_file_path)
    @environment_properties = JSON.parse(json_file)
  end


  #Step2: Prepare script-content by using `script_for_environment.mustache` file with EnvironmentProperties.json content.
  def prepare_script_content
    @script_content = ""
    #Loop Environment-Properties as per JSON input.
    @environment_properties.each do |environment_hash|
      environment = environment_hash["environment"]
      url = environment_hash["properties"]["URL"]
      hmac_key = environment_hash["properties"]["HMAC_KEY"]
      FastlaneCore::UI.important "👊 Found properties for environment: #{environment}."

      #Read script_for_environment.mustache file & Update mustache with real-value.
      script_environment_mustache_file_name = "script_for_environment.mustache"
      script_environment_mustache_file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{script_environment_mustache_file_name}"
      script_environment_mustache_file = File.open("#{script_environment_mustache_file_path}", "a+")
      script_environment_content = script_environment_mustache_file.read.to_s
      @script_content += script_environment_content % {:ENVIRONMENT => environment,
                                                      :URL => url,
                                                      :HMAC_KEY => hmac_key}
    end
  end


  #Step3: Generate shell-script file as per `create_ipa_with_environments.mustache` file with Step2 content.
  def generate_script_file_for_create_ipa
    #Read create_ipa_with_environments.mustache file & Update SCRIPT_CONTENT value.
    create_ipa_mustache_file_name = "create_ipa_for_environments.mustache"
    create_ipa_mustache_file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{create_ipa_mustache_file_name}"
    create_ipa_mustache_file = File.open("#{create_ipa_mustache_file_path}", "a+")
    create_ipa_file_content = create_ipa_mustache_file.read.to_s
    create_ipa_file_content = create_ipa_file_content % {:SCRIPT_CONTENT => @script_content}

    #Generate create_ipa_with_environments.sh file, which will responsible for create ipa files for all environments.
    create_ipa_script_file_name = File.basename(create_ipa_mustache_file_name, File.extname(create_ipa_mustache_file_name))
    create_ipa_script_file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{create_ipa_script_file_name}.sh"
    #Delete file if exist.
    if File.file?(create_ipa_script_file_path)
      File.delete(create_ipa_script_file_path)
    end
    #Generate create_ipa_with_environments.sh file.
    open(create_ipa_script_file_path, 'w+') do |file|
      file.puts create_ipa_file_content
    end
    FastlaneCore::UI.success "✅ Created shell-script file at path: #{create_ipa_script_file_path}\n\n"
  end

end


#Start Execution of Script.
SetupScriptForEnvironments.new.run
