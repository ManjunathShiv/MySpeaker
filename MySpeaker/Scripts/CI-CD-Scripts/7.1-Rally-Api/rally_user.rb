#!/usr/bin/env ruby

# RallyUser.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require_relative '1_http_call'
require 'json'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Rally User ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class RallyUser

  #
  # => Fetch the Rally User details by using Email address.
  #
  # => How to use:
  #    require_relative 'rally_user.rb'
  # => RallyUser.new.fetch "manish.rathi@philips.com"
  #
  # => Return:
  #    webservice response with body & status-code Access by using i.e response[:body], response[:code]
  #
  def fetch(email)
    puts "Fetching Rally User for Email => #{email}"
    url_path = "/user?query=(UserName = #{email.downcase})"
    response = HttpCall.new.get(url_path)
    puts "Fetching Rally User status-code => #{response[:code]}"
    response
  end


  #
  # => Fetch the Rally User-id by using Email address.
  #
  # => How to use:
  #    require_relative 'rally_user.rb'
  # => RallyUser.new.fetch_user_id "manish.rathi@philips.com"
  #
  # => Return:
  #    Rally user id i.e 210399454523 or "" in case of error
  #
  def fetch_user_id(email)
    puts "Fetching Rally User-Id for Email => #{email}"
    response = fetch(email)
    puts "Fetching Rally User-Id status-code => #{response[:code]}"
    json_response = JSON.parse(response[:body])
    user_id = ""
    if (json_response["QueryResult"]["Results"]).count > 0
      user_id = File.basename(json_response["QueryResult"]["Results"][0]["_ref"])
    end
    user_id
  end


  #
  # => Fetch the Rally User details by using DisplayName.
  #
  # => How to use:
  #    require_relative 'rally_user.rb'
  # => RallyUser.new.fetch_using_name "Manish Rathi"
  #
  # => Return:
  #    webservice response with body & status-code Access by using i.e response[:body], response[:code]
  #
  def fetch_using_name(name)
    puts "Fetching Rally User for Name => #{name}"
    url_path = "/user?query=(DisplayName = \"#{name}\")"
    response = HttpCall.new.get(url_path)
    puts "Fetching Rally User status-code => #{response[:code]}"
    response
  end


  #
  # => Fetch the Rally User-id by using DisplayName.
  #
  # => How to use:
  #    require_relative 'rally_user.rb'
  # => RallyUser.new.fetch_user_id_using_name "Manish Rathi"
  #
  # => Return:
  #    Rally user id i.e 210399454523 or "" in case of error
  #
  def fetch_user_id_using_name(name)
    puts "Fetching Rally User-Id for Name => #{name}"
    response = fetch_using_name(name)
    puts "Fetching Rally User-Id status-code => #{response[:code]}"
    json_response = JSON.parse(response[:body])
    user_id = ""
    if (json_response["QueryResult"]["Results"]).count > 0
      user_id = File.basename(json_response["QueryResult"]["Results"][0]["_ref"])
    end
    user_id
  end

end
