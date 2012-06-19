# authsome
authsome is a social-network/oauth proxy to provide a limited amount of information from restricted services to be used without authentication.

Primarily authsome has been designed to be used by javascript on [pancake.io](http://pancake.io).

Since it's not sensible to expose your private keys by embedding them in client-side code, authsome runs server-side and acts as an endpoint for http requests that provides JSON-formatted data in response.

## Installation

Populate a keys.yaml file with appropriate credential information. In the case of linkedin, key.yaml requires the pre-authenticated session key pair.

## Usage in pancake.io

Embedding the following into your markdown or html file will trigger the processing of the response data.

`<script language="javascript">
Authsome = {
  serverResponse: function(data) {
    // do something with the data here
  }
}
</script>
<script type="text/javascript" src="http://authsome-app-path/endpoint" />`

## Services and endpoints

Currently authsome supports:

* [linkedin](http://linkedin.com)
  * /linkedin/summary
* [lastfm](http://last.fm)
  * /lastfm/tracks
  * /lastfm/artists
* [twitter](http://twitter.com)
  * /twitter/tweets

Alternatively, to request all of the above, call:

* /everything

## Todo

* Add more services (such as github)
* Add non-volatile storage access, and then ...
* Bake in a oauth workflow to acquire the relevant keys without having to go elsewhere.

## Thanks

Major league thanks to Matt (@eightbitraptor) for holding my hand through all this.