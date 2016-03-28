require 'authsome/lastfm'
require 'authsome/twitter'
require 'authsome/linkedin'

require 'ostruct'
require 'yaml'
require 'json'
require 'dalli'

class Authsome < Sinatra::Base
  set :keys, OpenStruct.new(YAML.load(File.open('config/keys.yml')))
  set :cache, Dalli::Client.new('localhost:11211', {:expires_in => 600})

  def initialize(*args)
    super

    @authsome_service = {}

    Dir.glob("lib/authsome/*") do |file|
      plugin   = /lib\/authsome\/(.*)\.rb/.match(file)[1]
      instance = 'Authsome' << plugin.capitalize
      @authsome_service[plugin] = eval(instance + '.new(settings.keys.' << plugin << ')')

    end

  end

  def get_cache(methodname)
    output = settings.cache.get(methodname)
    if output.nil? then
      plugin = methodname.split('_')[0]
      settings.cache.set(methodname, @authsome_service[plugin].method(methodname).call)
      output = settings.cache.get(methodname)
    end

    result = {}
    result[methodname] = output

    return result
  end

  def json_wrap(results)
    output = get_cache(results)
    return "Authsome.serverData(" << JSON.generate(output) << ")"
  end

  def cache(response)
    cache_control :public, :must_revalidate, :max_age => 600
    last_modified Date.today
    etag Digest::MD5.hexdigest(response)
  end

  get '/everything' do
    result = {}
    %w(lastfm_getTracks lastfm_getArtists linkedin_getSummary twitter_getTweets).each { |setting| result[setting] = get_cache(setting)[setting] }
    response = "Authsome.serverData(" << JSON.generate(result) << ")"
    cache(response)
    response
  end

  get '/lastfm/tracks' do
    response = json_wrap('lastfm_getTracks')
    cache(response)
    response
  end

  get '/lastfm/artists' do
    response = json_wrap('lastfm_getArtists')
    cache(response)
    response
  end

  get '/linkedin/summary' do
    response = json_wrap('linkedin_getSummary')
    cache(response)
    response
  end

  get '/twitter/tweets' do
    response = json_wrap('twitter_getTweets')
    cache(response)
    response
  end

  get '*' do
    [404, "404 - no page found!"]
  end

end