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

      eval(instance + '.instance_methods(false)').each do |method|
        settings.cache.set(method, @authsome_service[plugin].method(method).call) if /#{plugin}/.match(method)
      end
    end

  end

  def get_cache(methodname)
    output = settings.cache.get(methodname)
    if output.nil? then
      plugin = methodname.split('_')[0]
      settings.cache.set(methodname, @authsome_service[plugin].method(methodname).call)
      output = settings.cache.get(methodname)
    end
    return output
  end

  def json_wrap(results)
    output = get_cache(results)
    "Authsome.serverData(" << JSON.generate(output) << ")"
  end

  get '/everything' do

    result = {}
    %w(lastfm_getTracks lastfm_getArtists linkedin_getSummary twitter_getTweets).each { |setting| result[setting] = get_cache(setting) }

    "Authsome.serverData(" << JSON.generate(result) << ")"
  end

  get '/lastfm/tracks' do
    json_wrap('lastfm_getTracks')
  end

  get '/lastfm/artists' do
    json_wrap('lastfm_getArtists')
  end

  get '/linkedin/summary' do
    json_wrap('linkedin_getSummary')
  end

  get '/twitter/tweets' do
    json_wrap('twitter_getTweets')
  end

  get '*' do
    [404, "404 - no page found!"]
  end

end