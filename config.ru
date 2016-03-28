require "rubygems"
require "bundler"
Bundler.setup(:default, :ci)
require "nokogiri"

# This is needed for ruby 1.9.2, but, @eightbitraptor says it 
# won't impact 1.9.3+, so is safe to leave.
# This way is best practice way to add items to the load path
$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require 'sinatra'
require File.expand_path("../lib/oauthproxy.rb", __FILE__)

app = Oauthproxy.new
run app
