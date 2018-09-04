#!/usr/bin/env ruby

# HockeyAppChangelog.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require 'redcarpet'
require "Fastlane"

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ TestReport Formatter ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class HockeyAppChangelog

  MARKDOWN_OPTIONS = {
  no_intra_emphasis: true,
  tables: true,
  fenced_code_blocks: true,
  autolink: true,
  strikethrough: true,
  space_after_headers: true,
  superscript: true,
  underline: true,
  highlight: true
  }.freeze

  def run
    change_log_file_path = ARGV[0]
    md_change_log = File.read(change_log_file_path)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTIONS)
    html_change_log = markdown.render(md_change_log)

    html_change_log_file_name = "Changelog.html"
    html_change_log_file_path = "#{File.dirname("#{change_log_file_path}")}/fastlane/reports/#{html_change_log_file_name}"
    open(html_change_log_file_path, 'w+') do |file|
      file.puts html_change_log
    end
    FastlaneCore::UI.success "\n\n✅ HTML changelog file has been generated at path: #{html_change_log_file_path}\n\n"
  end

end


HockeyAppChangelog.new.run
