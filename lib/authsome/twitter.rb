require 'twitter'

class AuthsomeTwitter

  def initialize(keys)
    @keys = keys
  end


  def twitter_getTweets
    tweets = []
    Twitter.user_timeline(@keys["user"]).first(5).each do |tweet|

      t = {
        "text" => tweet.text,
        "created" => tweet.created_at.to_i,
        "in_reply" => tweet.in_reply_to_status_id,
        "reply_to" => tweet.in_reply_to_screen_name
      }

       tweets.push(t)
    end
    return tweets
  end 

end