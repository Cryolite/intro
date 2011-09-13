#!/usr/bin/env ruby

require 'rubygems'
gem 'twitter'
require 'twitter'

# log in
Twitter.configure do |config|
  config.consumer_key = 'write-your-consumer-key'
  config.consumer_secret = 'write-your-consumer-secret'
  config.oauth_token = 'write-your-oauth-token'
  config.oauth_token_secret = 'write-your-oauth-token-secret'
end 

client = Twitter::Client.new
client.update(STDIN.gets)
