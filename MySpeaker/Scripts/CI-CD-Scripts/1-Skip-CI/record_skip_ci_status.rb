#!/usr/bin/env ruby

# RecordSkipCiStatus.rb
# version 1.0.0
# Contact manish.rathi@philips.com


require "Fastlane"

class RecordSkipCiStatus

  def run(skip_ci)
    file_name = ".skip_ci.txt"
    file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{file_name}"
    if File.file?(file_path)
      File.delete(file_path)
    end
    open(file_path, 'w+') do |file|
      file.puts skip_ci
    end
    FastlaneCore::UI.important "Recorded Skip CI Status in file: #{file_path}"
  end

end

RecordSkipCiStatus.new.run("#{ARGV[0]}")
