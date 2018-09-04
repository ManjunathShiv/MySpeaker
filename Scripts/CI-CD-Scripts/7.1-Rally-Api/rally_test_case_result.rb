#!/usr/bin/env ruby

# RallyTestCaseResult.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require_relative '1_http_call'
require 'json'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Rally TestCase Result ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class RallyTestCaseResult

  #
  # => Fetch the Rally TestCase Result with Json TestCase Body.
  #
  # => How to use:
  #    require_relative 'rally_test_case_result.rb'
  # => RallyTestCaseResult.new.update body
  #
  # JSON Body Example:
  # body = JSON.dump({
  #     "TestCaseResult" => {
  #       "Build" => "#{build_number}",
  #       "TestCase" => "/testcase/#{test_case_rally_id}",
  #       "Date" => "#{execution_date}",
  #       "Verdict" => "Pass",
  #       "Duration" => execution_duration in Float,
  #       "Notes" => "#{notes in HTML}",
  #       "Tester" => "#{user_rally_id}"
  #     }
  # })
  #
  #
  # => Return:
  #    webservice response with body & status-code Access by using i.e response[:body], response[:code]
  #
  def update(json_body)
    puts "Updating Rally TestCase Result"
    url_path = "/TestCaseResult/create"
    response = HttpCall.new.post(url_path, json_body)
    puts "Updating Rally TestCase Result status-code => #{response[:code]}"
    response
  end

end
