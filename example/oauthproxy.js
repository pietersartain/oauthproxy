/*
 *
 */

document.write("<h1>Tweets</h1><div id='oauthproxy_twitter_getTweets' class='' style='display: none'>No tweets found.</div>");
document.write("<h1>Last Played Tracks</h1><div id='oauthproxy_lastfm_getTracks' class='' style='display: none'>No last played tracks found.</div>");
document.write("<h1>Top Artists</h1><div id='oauthproxy_lastfm_getArtists' class='' style='display: none'>No favourite artists found.</div>");
document.write("<h1>LinkedIn Details</h1><div id='oauthproxy_linkedin_getSummary' class='' style='display: none'>No linkedin details found.</div>");

var querystring = new ScriptQuery('oauthproxy.js').parse();
var oauthproxy = "";

if (document.location['hostname'] == 'pancake.io') {
  oauthproxy = 'http://quiet-journey-2181.herokuapp.com/'
} else {
  oauthproxy = 'http://'+document.location['hostname']+':9292';
}


var month = new Array(12);
month[0]  = "January";
month[1]  = "February";
month[2]  = "March";
month[3]  = "April";
month[4]  = "May";
month[5]  = "June";
month[6]  = "July";
month[7]  = "August";
month[8]  = "September";
month[9]  = "October";
month[10] = "November";
month[11] = "December";

oauthproxy = (function() {

function requestContent() {
  var script = document.createElement('script');
  script.src = oauthproxy + '/' + querystring['src'];
  document.getElementsByTagName('head')[0].appendChild(script)
}

function timeAgo(time) {
  var seconds_diff = Date.now() - (new Date(time * 1000));
  var min_diff = Math.floor(seconds_diff / 1000 / 60);
  var hour_diff = 0;
  var day_diff = 0;

  if (min_diff > 60) { 
    hour_diff = Math.floor(min_diff / 60);
    if (hour_diff > 24) {
      day_diff = Math.floor(hour_diff / 24);
      // Week check
      return day_diff + " days ago";
    } else {
      return hour_diff + " hours ago";
    }
  } else {
    return min_diff + " minutes ago";
  }
}

this.twitter_getTweets = function(tweet) {
  str = '<div><p>'+tweet.text+'</p><span>'+timeAgo(tweet.created);
  if (tweet.in_reply != null) { str += ' in reply to @'+tweet.reply_to; }
  str += '</span></div>';
  return str;
}

this.lastfm_getArtists = function(artist) {
  return '<div><img src="'+artist.image+'" /><span>'+artist.rank+'. <a href="'+artist.url+'">'+artist.artist+'</a></span></div>';
}

this.lastfm_getTracks = function(track) { 
  return '<div><span>'+track.song+' by '+track.artist+'</span> <span id="date">'+timeAgo(track.date)+'</span></div>';
}

this.linkedin_getProfile = function(profile) {
  var p = profile['linkedin_getSummary'];
  str  = '<div class="profile">';
  str += '  <div class="header">';
  str += '    <img src="'+p.picture_url+'" />';
  str += '    <span class="name">'+p.first_name+' '+p.last_name+'</span>';
  str += '    <span class="headline">'+p.headline+'</span>';
  str += '  </div>'
  str += '  <p class="summary">'+p.summary+'</p>';
  str += '  <p class="specialties">Specialties: '+p.specialties+'</p>';
  str += '</div>';
  return str;
}

this.linkedin_getSummary = function(employers) {
  var str = "";
  employers.forEach(function(s) {
    var from = ""+month[s['start_date']['month']-1]+" "+s['start_date']['year'];
    var to = "";
    if (s['is_current']) { 
      to = "Present";
    } else {
      to   = ""+month[s['end_date']['month']-1]+" "+s['end_date']['year'];
    }

    str += '<div class="employers">';
    
    str += '  <span class="dates">'+from+' - '+to+'</span>';
    str += '  <span class="title">'+s['title']+' / </span><span class="company">'+s['company']['name']+'</span>';
    str += '  <p>'+s['summary']+'</p>';
    str += '</div>';
  });
  return str;
}

this.loop = function(data, methodname) {
  var doc = document.getElementById('oauthproxy_' + methodname);
  var str = "";
  data[methodname].forEach(function(item) { str += Oauthproxy[methodname](item); });
  //postmethod = Oauthproxy[methodname+"_post"];
  //if (postmethod && postmethod === "function") { postmethod(); }
  doc.innerHTML = str;
  doc.style.display = 'block';
}

this.serverData = function( data ) {
  if (!data) return;

  for (var methodname in data) {
    switch(methodname) {
      case 'twitter_getTweets':
      case 'lastfm_getArtists':
      case 'lastfm_getTracks':
        this.loop(data, methodname);
      break;
      case 'linkedin_getSummary':
        str = this.linkedin_getProfile(data);
        str += this.linkedin_getSummary(data[methodname].positions.all);
        var doc = document.getElementById('oauthproxy_' + methodname);
        doc.innerHTML = str;
        doc.style.display = 'block';
      break;
    }
  }

}

requestContent();
return this;
})();
