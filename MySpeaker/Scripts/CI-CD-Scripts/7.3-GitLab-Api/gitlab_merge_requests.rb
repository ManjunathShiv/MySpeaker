#!/usr/bin/env ruby

# GitLabMergeRequests.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require_relative '1_http_call'
require 'json'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Merge Requests ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class GitLabMergeRequests

  #
  # => Fetch the Last Gitlab merge_request details.
  #
  # => How to use:
  #    require_relative 'gitlab_merge_requests.rb'
  # => GitLabMergeRequests.new.last
  #
  # => Return:
  #    webservice response with body & status-code Access by using i.e response[:body], response[:code]
  #
  def last
    puts "Fetching Gitlab Last merge_request"
    url_path = "/merge_requests?scope=all"
    response = HttpCall.new.get(url_path)
    puts "Fetching Gitlab Last merge_request status-code => #{response[:code]}"
    json_response = JSON.parse(response[:body])
    json_response[0]
  end

end
