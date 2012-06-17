# authsome
authsome is a social-network/oauth proxy to provide a limited amount of information from restricted services to be used without authentication.

Primarily authsome has been designed to be used by javascript on [pancake.io](http;//pancake.io).

Since it's not sensible to expose your private keys by embedding them in client-side code, authsome runs server-side and acts as an endpoint for http requests that provides JSON-formatted data in response.

## Installation

Populate the keys.yaml file with appropriate credential information. In the case of linkedin, key.yaml requires the pre-authenticated session key pair.

## Valid endpoints

* /everything
* /lastfm/tracks
* /lastfm/artists
* /linkedin/summary
* /twitter/tweets

## Services

Currently authsome supports:

* [linkedin](linkedin.com)
* [lastfm](last.fm)
* [twitter](twitter.com)

## Todo

* Add more services (such as github)
* Add non-volatile storage access, and then ...
* Bake in a oauth workflow to acquire the relevant keys without having to go elsewhere.