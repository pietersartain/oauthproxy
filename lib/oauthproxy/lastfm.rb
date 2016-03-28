require 'nokogiri'
require 'open-uri'

class OauthproxyLastfm

  def initialize(keys)
    @keys = keys
  end

  def lastfm_getArtists
    # http://www.last.fm/api/show/user.getTopArtists
    xmlfeed = 'http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=' << @keys["user"] << '&limit=50&api_key=' << @keys["api"]

    doc = Nokogiri::XML(open(xmlfeed))

    # Read the top 3 artists, and then a random scattering of the other 50.
    samples = [1, 2, 3] + (4..50).to_a.sample(7)

    scattering = []
    samples.shuffle.each do |s|
      info = doc.css("artist[rank='#{s}']")

      scattering.push({
        "artist" => info.css("name").text,
        "rank"   => "#{s}",
        "url"    => info.css("url").text,
        "count"  => info.css("playcount").text,
        "image"  => info.css("image[size='extralarge']").text
        })
    end

    return scattering
  end

  def lastfm_getTracks
    # http://www.last.fm/api/show/user.getRecentTracks
    xmlfeed = 'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=' << @keys["user"] << '&api_key=' << @keys["api"]

    doc = Nokogiri::XML(open(xmlfeed))

    tracks = []

    doc.css('track').each() do |track|

      artist = track.css('artist').text
      album  = track.css('album').text
      song   = track.css('name').text
      date   = track.css('date').first

      date = date["uts"] unless date.nil?

      track_info = {"artist" => artist, "album" => album, "song" => song, "date" => date}
      tracks.push(track_info)
    end

    return tracks
  end

end
