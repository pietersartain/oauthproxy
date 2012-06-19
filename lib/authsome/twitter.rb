require 'twitter'

class AuthsomeTwitter

  def initialize(keys)
    @keys = keys
  end


  def twitter_getTweets
    tweets = []
    Twitter.user_timeline(@keys["user"]).first(5).each do |tweet|
       tweets.push(tweet.text)
    end
    return tweets
  end 

end