#!/usr/bin/env ruby

# RallyTestCase.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require_relative '1_http_call'
require 'json'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Rally TestCase ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class RallyTestCase

  #
  # => Fetch the Rally TestCase details by using TestCase Number.
  #
  # => How to use:
  #    require_relative 'rally_test_case.rb'
  # => RallyTestCase.new.fetch "TC4330"
  #
  # => Return:
  #    webservice response with body & status-code Access by using i.e response[:body], response[:code]
  #
  def fetch(test_case_number)
    puts "Fetching Rally TestCase for TC => #{test_case_number}"
    url_path = "/testcase?query=(FormattedID = #{test_case_number})"
    response = HttpCall.new.get(url_path)
    puts "Fetching Rally TestCase status-code => #{response[:code]}"
    response
  end


  #
  # => Fetch the Rally TestCase-id by using TestCase Number.
  #
  # => How to use:
  #    require_relative 'rally_test_case.rb'
  # => RallyTestCase.new.fetch_test_case_id "TC4330"
  #
  # => Return:
  #    Rally TestCase id i.e 210399454523 or "" in case of error
  #
  def fetch_test_case_id(test_case_number)
    puts "Fetching Rally TestCase-Id for TC => #{test_case_number}"
    response = fetch(test_case_number)
    puts "Fetching Rally TestCase-Id status-code => #{response[:code]}"
    json_response = JSON.parse(response[:body])
    test_case_id = ""
    if (json_response["QueryResult"]["Results"]).count > 0
      test_case_id = File.basename(json_response["QueryResult"]["Results"][0]["_ref"])
    end
    test_case_id
  end

end
