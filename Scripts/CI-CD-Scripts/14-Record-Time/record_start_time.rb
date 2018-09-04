#!/usr/bin/env ruby

# RecordStartTime.rb
# version 1.0.0
# Contact manish.rathi@philips.com


require "Fastlane"

class RecordStartTime

  def run(start_time)
    FastlaneCore::UI.important "📌 Script Execution Start time: #{start_time}"
    file_name = ".start_time.txt"
    file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{file_name}"
    if File.file?(file_path)
      File.delete(file_path)
    end
    open(file_path, 'w+') do |file|
      file.puts start_time
    end
    FastlaneCore::UI.important "Recorded Execution Start time in file: #{file_path}"
  end

end

RecordStartTime.new.run("#{ARGV[0]} #{ARGV[1]} #{ARGV[2]}")
