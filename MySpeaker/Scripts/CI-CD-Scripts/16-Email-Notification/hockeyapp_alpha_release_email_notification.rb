#!/usr/bin/env ruby

# HockeyAppAlphaReleaseNotification.rb
# version 1.0.0
# Contact manish.rathi@philips.com


require "Fastlane"

class HockeyAppAlphaReleaseNotification

  def run(app_version)

    #Read Template
    template_file_name = "hockeyapp_alpha_release_sucess_template.html"
    template_file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{template_file_name}"
    template_file = File.open("#{template_file_path}", "a+")
    template_file_content = template_file.read.to_s.strip
    email_body_content = template_file_content % {:version => app_version}

    #Write Email body content
    file_name = ".hockeyapp_alpha_release_email_notification.html"
    file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{file_name}"
    if File.file?(file_path)
      File.delete(file_path)
    end
    open(file_path, 'w+') do |file|
      file.puts email_body_content
    end
    FastlaneCore::UI.success "\nGenerated Email Notification body content in file: #{file_path}"

  end

end

HockeyAppAlphaReleaseNotification.new.run(ARGV[0])
