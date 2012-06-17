require 'authsome/lastfm'
require 'authsome/twitter'
require 'authsome/linkedin'

require 'ostruct'
require 'yaml'
require 'json'

class Authsome < Sinatra::Base
  set :keys, OpenStruct.new(YAML.load(File.open('config/keys.yml')))

  # Just like PHP/Kohana, extend the constructor
  def initialize(*args)
    super
    @m_lastfm = AuthsomeLastfm.new(settings.keys.lastfm)
    @m_linkedin = AuthsomeLinkedin.new(settings.keys.linkedin)
    @m_twitter = AuthsomeTwitter.new(settings.keys.twitter)
  end

  get '/everything' do

    all = {
      "lastfm_tracks"    => @m_lastfm.getTracks,
      "lastfm_artists"   => @m_lastfm.getArtists,
      "linkedin_summary" => @m_linkedin.getSummary,
      "twitter"          => @m_twitter.getTweets
    }

    JSON.generate(all)
  end

  get '/lastfm/tracks' do
    JSON.generate(@m_lastfm.getTracks)
  end

  get '/lastfm/artists' do
    JSON.generate(@m_lastfm.getArtists)
  end

  get '/linkedin/summary' do
    JSON.generate(@m_linkedin.getSummary)
  end

  get '/twitter/tweets' do
    JSON.generate(@m_twitter.getTweets)
  end

  get '*' do
    [404, "404 - no page found!"]
  end

end