# 
#  RailsHelper.rb
#  MSO Intern
#  
#  Created by Stefan Diesing on 2012-05-16.
#  Copyright 2012 Stefan Diesing. All rights reserved.
# 

# TODO
# request with a proxy

require 'net/http'
require 'net/https'

# keep this module as general es posible so it can be useful for other rails apps
module RailsHelper
  
  # Get the token as well as the session cookie
  # optional cookie can be passed to stay in a session
  # returns [token, cookie]
  def get_token(url, cookie = "")
    response = https_get(url,cookie)
    response[1] =~ /\<input name\=\"authenticity_token\" type\=\"hidden\" value\=\"(.*)\" \/\>/
    return [$1, response[0]['set-cookie'].split(';')[0]]
  end

  # logs into an rails app
  # on sucsees returns the session_id cookie as string
  def login(url, username, password)
    token = get_token(url)
    response = https_post url, "authenticity_token=#{token[0]}&user[login]=#{username}&user[password]=#{password}", token[1]
    raise "No redirect occured: server did not accept the request." unless response[0]["status"] == "302"
  
    return response[0]['set-cookie'].split(';')[0]
  end
  
  # send an https get request
  # returns metainfo and the body as an array
  def https_get(url, cookie = "")
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    meta, body = http.request_get uri.path, 'User-Agent' => "Mozilla/5.0 RailsAppHelper", 'Cookie' => cookie
    return [meta, body]
  end

  # send an https post request with data
  # returns metainfo and the body as an array
  def https_post(url, data, cookie = "")
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    resp, body = http.request_post uri.path, data, 'User-Agent' => "Mozilla/5.0 RailsAppHelper", 'Cookie' => cookie
    return [resp, body]
  end
  
end