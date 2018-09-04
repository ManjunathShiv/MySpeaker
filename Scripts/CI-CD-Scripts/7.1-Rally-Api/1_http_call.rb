#!/usr/bin/env ruby

# HttpCall.rb
# version 1.0.0
# Contact manish.rathi@philips.com

require 'net/http'
require 'uri'
require 'json'
require_relative '0_config'

#≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠ Http web service call ≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
class HttpCall
  attr_accessor :config

  def initialize
    @config = Config.new
    ENV['http_proxy'] = @config.http_proxy
  end

  def get(url_path)
    perform(:get, url_path, nil)
  end

  def post(url_path, body)
    perform(:post, url_path, body)
  end

  def perform(type, url_path, body)
    url = "#{@config.base_url}/webservice/#{@config.webservice_version}#{url_path}"

    uri = URI.parse(url)
    request = type == :post ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
    request.content_type = @config.content_type
    request["Zsessionid"] = @config.api_token
    request.body = body
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    {:body => response.body, :code => response.code}
  end

end
