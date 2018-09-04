#!/usr/bin/env ruby

# RecordExecutionTime.rb
# version 1.0.0
# Contact manish.rathi@philips.com


require "Fastlane"

class RecordExecutionTime

  def run(file_path)
    start_time_file_name = ".start_time.txt"
    start_time_file_path = "#{File.expand_path(File.dirname(__FILE__))}/#{start_time_file_name}"
    start_time_file = File.open("#{start_time_file_path}", "a+")
    start_time = start_time_file.read.to_s.strip

    FastlaneCore::UI.important "📌 Script Execution Start time: #{start_time}"
    FastlaneCore::UI.important "📌 Script Execution End time: #{Time.now}"

    started_time = Time.parse("#{start_time}")
    duration = Time.now - started_time

    existing_duration = 0
    file = File.open("#{file_path}", "a+")
    existing_duration = file.read.to_i

    File.open("#{file_path}", 'w+') do |f|
      duration += existing_duration
      f.puts(duration)
    end

    duration_minutes = (duration / 60.0).round
    if duration_minutes == 0
      FastlaneCore::UI.success "🎙 Total #{duration.round} seconds saved till now 🎉"
    elsif duration_minutes >= 60
      mm, ss = duration.divmod(60)
      hh, mm = mm.divmod(60)
      if hh == 1
        FastlaneCore::UI.success "🎙 Total #{hh} hour #{mm} minutes  saved till now 🎉"
      else
        FastlaneCore::UI.success "🎙 Total #{hh} hours #{mm} minutes saved till now 🎉"
      end
    else
      FastlaneCore::UI.success "🎙 Total #{duration_minutes} minutes saved till now 🎉"
    end
  end

end

RecordExecutionTime.new.run(ARGV[0])
