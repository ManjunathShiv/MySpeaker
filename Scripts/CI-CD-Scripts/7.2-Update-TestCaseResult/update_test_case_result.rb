#!/usr/bin/env ruby

# UpdateTestCaseResult.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require 'fastlane_core'
require 'json'
require_relative '../7.1-Rally-Api/rally_user'
require_relative '../7.1-Rally-Api/rally_test_case'
require_relative '../7.1-Rally-Api/rally_test_case_result'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Update TestCase Result ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class UpdateTestCaseResult
  attr_accessor :rally_test_case, :rally_test_case_result, :json_data_hash, :tester_rally_id

  def initialize
    @rally_test_case = RallyTestCase.new
    @rally_test_case_result = RallyTestCaseResult.new
  end

  def run
    parse_json
    fetch_tester_rally_id
    start_updating_test_case_result
  end

  def parse_json
    json_file = File.read(ARGV[0])
    @json_data_hash = JSON.parse(json_file)
  end

  def fetch_tester_rally_id
    @tester_rally_id = RallyUser.new.fetch_user_id_using_name(@json_data_hash["approver"])
  end

  def fetch_test_case_rally_id(test_case_number)
    @test_case_rally_id = @rally_test_case.fetch_test_case_id(test_case_number)
  end

  def start_updating_test_case_result
    @json_data_hash["test_cases"].each do |testCase|
      test_cases = testCase["test_case"].split(' ')
      test_cases.each do |test_case_number|
        puts ""
        test_case_rally_id = fetch_test_case_rally_id(test_case_number)
        if test_case_rally_id.length > 0
          FastlaneCore::UI.success "✅ Updating TestCase: #{testCase["identifier"]} result."
          update_test_case(testCase, test_case_rally_id)
        else
          FastlaneCore::UI.error "🚫 TestCase: #{testCase["identifier"]} not found. SKIPing"
        end
      end
    end
  end

  def update_test_case(test_case, test_case_rally_id)
    notes = notes_template % {:author => @json_data_hash["author"],
                              :approver => @json_data_hash["approver"],
                              :device_name => @json_data_hash["device_name"],
                              :device_version =>  @json_data_hash["device_version"],
                              :current_git_commit_url => @json_data_hash["current_git_commit_url"],
                              :current_commit_hash => @json_data_hash["current_commit_hash"],
                              :git_file_path => test_case["git_file_path"],
                              :name => test_case["name"]
                              }

    body = JSON.dump({
      "TestCaseResult" => {
        "Build" => "#{@json_data_hash["build_version_number"]}",
        "TestCase" => "/testcase/#{test_case_rally_id}",
        "Date" => "#{@json_data_hash["execution_date"]}",
        "Verdict" => "#{test_case["status"]}",
        "Duration" => "#{test_case["duration"]}".to_f.round(2),
        "Notes" => "#{notes}",
        "c_OS" => "iOS #{@json_data_hash["device_version"]}",
        "Tester" => "#{@tester_rally_id}"
      }
    })

    @rally_test_case_result.update(body)
  end

  def notes_template
    '<br/><font size="2">Author: </font> %{author}
    <br/><font size="2">Approver: </font> %{approver}
    <br/><font size="2">Device Details: </font> %{device_name}
    <br/><font size="2">OS Version: </font> iOS %{device_version}
    <br/><font size="2">Test Executed on Git Revision: </font><a href=%{current_git_commit_url} target=_blank>%{current_commit_hash} </a>
    <br/><font size="2">Test Location: </font><a href=%{git_file_path} target=_blank>%{name} </a>
    <br/>'
  end

end


UpdateTestCaseResult.new.run
