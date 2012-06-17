require 'twitter'

class AuthsomeTwitter

  def initialize(keys)
    @keys = keys
  end


  def getTweets

#    Twitter.configure { |config| config.proxy = "http://192.168.44.98:3128" }

    tweets = []
    Twitter.user_timeline(@keys["user"]).first(5).each do |tweet|
       tweets.push(tweet.text)
    end
    return tweets
  end 

end # endclass