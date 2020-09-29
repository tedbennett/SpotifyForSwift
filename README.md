# Spotify For Swift 🎶

Wrapper for the Spotify Music API written in Swift

## Description

This is a package to make interacting with the Spotify API a lot easier. It's a pretty nice API to deal with, but this package will automatically handle things like paginated responses, too many requests, and a few of the API's oddities (like externally hosted music...)

I decided to create this after trying to build an app for sharing playlists between Apple Music and Spotify, and getting pretty frustrated working with the API.

So far, this package can perform only the most basic interactions with the API, but it can handle paginated responses and the Too Many Requests error. See below for the full list of implemented capabilities

This package depends on the OAuth2 package to handle authentication

## To-Do
- Obviously, implement all endpoints!
- Improve error handling, give more verbose response, including:
    - Insufficient client scope
    - Auth errors
- Work on extra auth flows
- Work on better handling incomplete data, such as that returned from local files in playlists
- Work on cases with uncommon response formats, e.g playlists containing tracks or episodes

## Full table of implemented endpoints

API Endpoint | Implemented? | Notes
--- | :---: | ---:
`GET https://api.spotify.com/v1/albums` | ✅ |
`GET https://api.spotify.com/v1/albums/{id}` | ✅ |
`GET https://api.spotify.com/v1/artists` | ✅ |
`GET https://api.spotify.com/v1/artists/{id}` | ✅ |
`GET https://api.spotify.com/v1/artists/{id}/top-tracks` | ✅ |
`GET https://api.spotify.com/v1/artists/{id}/related-artists` | ✅ |
`GET https://api.spotify.com/v1/artists/{id}/albums` | ✅ |
`GET https://api.spotify.com/v1/browse/new-releases` | ❌ |
`GET https://api.spotify.com/v1/browse/featured-playlists` | ❌ |
`GET https://api.spotify.com/v1/browse/categories` | ❌ |
`GET https://api.spotify.com/v1/browse/categories/{category_id}` | ❌ |
`GET https://api.spotify.com/v1/browse/categories/{category_id}/playlists` | ❌ |
`GET https://api.spotify.com/v1/recommendations` | ❌ |
`GET https://api.spotify.com/v1/episodes` | ❌ |
`GET https://api.spotify.com/v1/episodes/{id}` | ❌ |
`PUT https://api.spotify.com/v1/playlists/{playlist_id}/followers` | ❌ |
`DELETE https://api.spotify.com/v1/playlists/{playlist_id}/followers` | ❌ |
`GET https://api.spotify.com/v1/playlists/{playlist_id}/followers/contains` | ❌ |
`GET https://api.spotify.com/v1/me/following` | ❌ |
`PUT https://api.spotify.com/v1/me/following` | ❌ |
`DELETE https://api.spotify.com/v1/me/following` | ❌ |
`GET https://api.spotify.com/v1/me/following/contains` | ❌ |
`GET https://api.spotify.com/v1/me/albums` | ✅ |
`PUT https://api.spotify.com/v1/me/albums` | ❌ |
`DELETE https://api.spotify.com/v1/me/albums` | ❌ |
`GET https://api.spotify.com/v1/me/albums/contains` | ❌ |
`GET https://api.spotify.com/v1/me/tracks` | ✅ |
`PUT https://api.spotify.com/v1/me/tracks` | ❌ |
`DELETE https://api.spotify.com/v1/me/tracks` | ❌ |
`GET https://api.spotify.com/v1/me/tracks/contains` | ❌ |
`GET https://api.spotify.com/v1/me/shows` | ❌ |
`PUT https://api.spotify.com/v1/me/shows` | ❌ |
`DELETE https://api.spotify.com/v1/me/shows` | ❌ |
`GET https://api.spotify.com/v1/me/shows/contains` | ❌ |
`GET https://api.spotify.com/v1/me/top/{type}` | ❌ |
`GET https://api.spotify.com/v1/me/player` | ❌ |
`PUT https://api.spotify.com/v1/me/player` | ❌ |
`GET https://api.spotify.com/v1/me/player/devices` | ❌ |
`GET https://api.spotify.com/v1/me/player/currently-playing` | ❌ |
`PUT https://api.spotify.com/v1/me/player/play` | ❌ |
`PUT https://api.spotify.com/v1/me/player/pause` | ❌ |
`POST https://api.spotify.com/v1/me/player/next` | ❌ |
`POST https://api.spotify.com/v1/me/player/previous` | ❌ |
`PUT https://api.spotify.com/v1/me/player/seek` | ❌ |
`PUT https://api.spotify.com/v1/me/player/repeat` | ❌ |
`PUT https://api.spotify.com/v1/me/player/volume` | ❌ |
`PUT https://api.spotify.com/v1/me/player/shuffle` | ❌ |
`GET https://api.spotify.com/v1/me/player/recently-played` | ❌ |
`POST https://api.spotify.com/v1/me/player/queue` | ❌ |
`GET https://api.spotify.com/v1/me/playlists` | ✅ |
`GET https://api.spotify.com/v1/users/{user_id}/playlists` | ✅ |
`POST https://api.spotify.com/v1/users/{user_id}/playlists` | ❌ |
`GET https://api.spotify.com/v1/playlists/{playlist_id}` | ✅ |
`PUT https://api.spotify.com/v1/playlists/{playlist_id}` | ❌ |
`GET https://api.spotify.com/v1/playlists/{playlist_id}/tracks` | ✅ |
`POST https://api.spotify.com/v1/playlists/{playlist_id}/tracks` | ❌ |
`PUT https://api.spotify.com/v1/playlists/{playlist_id}/tracks` | ❌ |
`DELETE https://api.spotify.com/v1/playlists/{playlist_id}/tracks` | ❌ |
`GET https://api.spotify.com/v1/playlists/{playlist_id}/images` | ✅ |
`PUT https://api.spotify.com/v1/playlists/{playlist_id}/images` | ❌ |
`GET https://api.spotify.com/v1/search` | ✅ |
`GET https://api.spotify.com/v1/shows` | ❌ |
`GET https://api.spotify.com/v1/shows/{id}` | ❌ |
`GET https://api.spotify.com/v1/shows/{id}/episodes` | ❌ |
`GET https://api.spotify.com/v1/tracks` | ✅ |
`GET https://api.spotify.com/v1/tracks/{id}` | ✅ |
`GET https://api.spotify.com/v1/audio-features` | ❌ |
`GET https://api.spotify.com/v1/audio-features/{id}` | ❌ |
`GET https://api.spotify.com/v1/audio-analysis/{id}` | ❌ |
`GET https://api.spotify.com/v1/me` | ✅ |
`GET https://api.spotify.com/v1/users/{user_id}` | ❌ |

