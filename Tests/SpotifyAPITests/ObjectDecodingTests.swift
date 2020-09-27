import XCTest
@testable import SpotifyAPI

final class ObjectDecodingTests: XCTestCase {

    // MARK: - Spotify API Object decoding tests
    
    func testAlbumDecoding() {
        let json = """
          {
          "album_type" : "album",
          "artists" : [ {
            "external_urls" : {
              "spotify" : "https://open.spotify.com/artist/2BTZIqw0ntH9MvilQ3ewNY"
            },
            "href" : "https://api.spotify.com/v1/artists/2BTZIqw0ntH9MvilQ3ewNY",
            "id" : "2BTZIqw0ntH9MvilQ3ewNY",
            "name" : "Cyndi Lauper",
            "type" : "artist",
            "uri" : "spotify:artist:2BTZIqw0ntH9MvilQ3ewNY"
          } ],
          "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TW", "UY" ],
          "copyrights" : [ {
            "text" : "(P) 2000 Sony Music Entertainment Inc.",
            "type" : "P"
          } ],
          "external_ids" : {
            "upc" : "5099749994324"
          },
          "external_urls" : {
            "spotify" : "https://open.spotify.com/album/0sNOF9WDwhWunNAHPD3Baj"
          },
          "genres" : [ ],
          "href" : "https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj",
          "id" : "0sNOF9WDwhWunNAHPD3Baj",
          "images" : [ {
            "height" : 640,
            "url" : "https://i.scdn.co/image/07c323340e03e25a8e5dd5b9a8ec72b69c50089d",
            "width" : 640
          }, {
            "height" : 300,
            "url" : "https://i.scdn.co/image/8b662d81966a0ec40dc10563807696a8479cd48b",
            "width" : 300
          }, {
            "height" : 64,
            "url" : "https://i.scdn.co/image/54b3222c8aaa77890d1ac37b3aaaa1fc9ba630ae",
            "width" : 64
          } ],
          "name" : "She's So Unusual",
          "popularity" : 39,
          "release_date" : "1983",
          "release_date_precision" : "year",
          "tracks" : {
            "href" : "https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj/tracks?offset=0&limit=50",
            "items" : [ {
              "artists" : [ {
                "external_urls" : {
                  "spotify" : "https://open.spotify.com/artist/2BTZIqw0ntH9MvilQ3ewNY"
                },
                "href" : "https://api.spotify.com/v1/artists/2BTZIqw0ntH9MvilQ3ewNY",
                "id" : "2BTZIqw0ntH9MvilQ3ewNY",
                "name" : "Cyndi Lauper",
                "type" : "artist",
                "uri" : "spotify:artist:2BTZIqw0ntH9MvilQ3ewNY"
              } ],
              "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "IE", "IS", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PT", "PY", "RO", "SE", "SG", "SI", "SK", "SV", "TW", "UY" ],
              "disc_number" : 1,
              "duration_ms" : 305560,
              "explicit" : false,
              "external_urls" : {
                "spotify" : "https://open.spotify.com/track/3f9zqUnrnIq0LANhmnaF0V"
              },
              "href" : "https://api.spotify.com/v1/tracks/3f9zqUnrnIq0LANhmnaF0V",
              "id" : "3f9zqUnrnIq0LANhmnaF0V",
              "name" : "Money Changes Everything",
              "preview_url" : "https://p.scdn.co/mp3-preview/01bb2a6c9a89c05a4300aea427241b1719a26b06",
              "track_number" : 1,
              "type" : "track",
              "uri" : "spotify:track:3f9zqUnrnIq0LANhmnaF0V"
            },
            ],
            "limit" : 50,
            "next" : null,
            "offset" : 0,
            "previous" : null,
            "total" : 13
          },
          "type" : "album",
          "uri" : "spotify:album:0sNOF9WDwhWunNAHPD3Baj"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var album: Album?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            album = try decoder.decode(Album.self, from: data)
        }  catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        XCTAssertNotNil(album)
    }
    
    func testArtistDecoding() {
        let json = """
          {
          "external_urls" : {
            "spotify" : "https://open.spotify.com/artist/0OdUWJ0sBjDrqHygGUXeCF"
          },
          "followers" : {
            "href" : null,
            "total" : 306565
          },
          "genres" : [ "indie folk", "indie pop" ],
          "href" : "https://api.spotify.com/v1/artists/0OdUWJ0sBjDrqHygGUXeCF",
          "id" : "0OdUWJ0sBjDrqHygGUXeCF",
          "images" : [ {
            "height" : 816,
            "url" : "https://i.scdn.co/image/eb266625dab075341e8c4378a177a27370f91903",
            "width" : 1000
          }, {
            "height" : 522,
            "url" : "https://i.scdn.co/image/2f91c3cace3c5a6a48f3d0e2fd21364d4911b332",
            "width" : 640
          }, {
            "height" : 163,
            "url" : "https://i.scdn.co/image/2efc93d7ee88435116093274980f04ebceb7b527",
            "width" : 200
          }, {
            "height" : 52,
            "url" : "https://i.scdn.co/image/4f25297750dfa4051195c36809a9049f6b841a23",
            "width" : 64
          } ],
          "name" : "Band of Horses",
          "popularity" : 59,
          "type" : "artist",
          "uri" : "spotify:artist:0OdUWJ0sBjDrqHygGUXeCF"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var artist: Artist?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            artist = try decoder.decode(Artist.self, from: data)
        }  catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        print(artist)
        XCTAssertNotNil(artist)
    }
    
    func testPlaylistDecoding() {
        let json = """
          {
            "collaborative": false,
            "description": "Having friends over for dinner? Here´s the perfect playlist.",
            "external_urls": {
                "spotify": "http://open.spotify.com/user/spotify/playlist/59ZbFPES4DQwEjBpWHzrtC"
            },
            "followers": {
                "href": null,
                "total": 143350
            },
            "href": "https://api.spotify.com/v1/users/spotify/playlists/59ZbFPES4DQwEjBpWHzrtC",
            "id": "59ZbFPES4DQwEjBpWHzrtC",
            "images": [
                {
                    "url": "https://i.scdn.co/image/68b6a65573a55095e9c0c0c33a274b18e0422736"
                }
            ],
            "name": "Dinner with Friends",
            "owner": {
                "external_urls": {
                    "spotify": "http://open.spotify.com/user/spotify"
                },
                "href": "https://api.spotify.com/v1/users/spotify",
                "id": "spotify",
                "type": "user",
                "uri": "spotify:user:spotify"
            },
            "public": null,
            "snapshot_id": "bNLWdmhh+HDsbHzhckXeDC0uyKyg4FjPI/KEsKjAE526usnz2LxwgyBoMShVL+z+",
            "tracks": {
                "href": "https://api.spotify.com/v1/users/spotify/playlists/59ZbFPES4DQwEjBpWHzrtC/tracks",
                "items": [
                    {
                        "added_at": "2014-09-01T04:21:28Z",
                        "added_by": {
                            "external_urls": {
                                "spotify": "http://open.spotify.com/user/spotify"
                            },
                            "href": "https://api.spotify.com/v1/users/spotify",
                            "id": "spotify",
                            "type": "user",
                            "uri": "spotify:user:spotify"
                        },
                        "is_local": false,
                        "track": {
                            "album": {
                                "album_type": "single",
                                "available_markets": [
                                    "AD",
                                    "AR",
                                    "AT",
                                    "AU",
                                    "BE",
                                    "BG",
                                    "BO",
                                    "BR",
                                    "CH",
                                    "CL",
                                    "CO",
                                    "CR",
                                    "CY",
                                    "CZ",
                                    "DK",
                                    "DO",
                                    "EC",
                                    "EE",
                                    "ES",
                                    "FI",
                                    "FR",
                                    "GB",
                                    "GR",
                                    "GT",
                                    "HK",
                                    "HN",
                                    "HU",
                                    "IE",
                                    "IS",
                                    "IT",
                                    "LI",
                                    "LT",
                                    "LU",
                                    "LV",
                                    "MC",
                                    "MT",
                                    "MY",
                                    "NI",
                                    "NL",
                                    "NO",
                                    "NZ",
                                    "PA",
                                    "PE",
                                    "PH",
                                    "PL",
                                    "PT",
                                    "PY",
                                    "RO",
                                    "SE",
                                    "SG",
                                    "SI",
                                    "SK",
                                    "SV",
                                    "TR",
                                    "TW",
                                    "UY"
                                ],
                                "external_urls": {
                                    "spotify": "https://open.spotify.com/album/5GWoXPsTQylMuaZ84PC563"
                                },
                                "href": "https://api.spotify.com/v1/albums/5GWoXPsTQylMuaZ84PC563",
                                "id": "5GWoXPsTQylMuaZ84PC563",
                                "images": [
                                    {
                                        "height": 640,
                                        "url": "https://i.scdn.co/image/47421900e7534789603de84c03a40a826c058e45",
                                        "width": 640
                                    },
                                    {
                                        "height": 300,
                                        "url": "https://i.scdn.co/image/0d447b6faae870f890dc5780cc58d9afdbc36a1d",
                                        "width": 300
                                    },
                                    {
                                        "height": 64,
                                        "url": "https://i.scdn.co/image/d926b3e5f435ef3ac0874b1ff1571cf675b3ef3b",
                                        "width": 64
                                    }
                                ],
                                "name": "I''m Not The Only One",
                                "type": "album",
                                "uri": "spotify:album:5GWoXPsTQylMuaZ84PC563"
                            },
                            "artists": [
                                {
                                    "external_urls": {
                                        "spotify": "https://open.spotify.com/artist/2wY79sveU1sp5g7SokKOiI"
                                    },
                                    "href": "https://api.spotify.com/v1/artists/2wY79sveU1sp5g7SokKOiI",
                                    "id": "2wY79sveU1sp5g7SokKOiI",
                                    "name": "Sam Smith",
                                    "type": "artist",
                                    "uri": "spotify:artist:2wY79sveU1sp5g7SokKOiI"
                                }
                            ],
                            "available_markets": [
                                "AD",
                                "AR",
                                "AT",
                                "AU",
                                "BE",
                                "BG",
                                "BO",
                                "BR",
                                "CH",
                                "CL",
                                "CO",
                                "CR",
                                "CY",
                                "CZ",
                                "DK",
                                "DO",
                                "EC",
                                "EE",
                                "ES",
                                "FI",
                                "FR",
                                "GB",
                                "GR",
                                "GT",
                                "HK",
                                "HN",
                                "HU",
                                "IE",
                                "IS",
                                "IT",
                                "LI",
                                "LT",
                                "LU",
                                "LV",
                                "MC",
                                "MT",
                                "MY",
                                "NI",
                                "NL",
                                "NO",
                                "NZ",
                                "PA",
                                "PE",
                                "PH",
                                "PL",
                                "PT",
                                "PY",
                                "RO",
                                "SE",
                                "SG",
                                "SI",
                                "SK",
                                "SV",
                                "TR",
                                "TW",
                                "UY"
                            ],
                            "disc_number": 1,
                            "duration_ms": 204732,
                            "explicit": false,
                            "external_ids": {
                                "isrc": "GBUM71403920"
                            },
                            "external_urls": {
                                "spotify": "https://open.spotify.com/track/4i9sYtSIlR80bxje5B3rUb"
                            },
                            "href": "https://api.spotify.com/v1/tracks/4i9sYtSIlR80bxje5B3rUb",
                            "id": "4i9sYtSIlR80bxje5B3rUb",
                            "name": "I''m Not The Only One - Radio Edit",
                            "popularity": 45,
                            "preview_url": "https://p.scdn.co/mp3-preview/dd64cca26c69e93ea78f1fff2cc4889396bb6d2f",
                            "track_number": 1,
                            "type": "track",
                            "uri": "spotify:track:4i9sYtSIlR80bxje5B3rUb"
                        }
                    }
                ],
                "limit": 100,
                "next": "https://api.spotify.com/v1/users/spotify/playlists/59ZbFPES4DQwEjBpWHzrtC/tracks?offset=100&limit=100",
                "offset": 0,
                "previous": null,
                "total": 105
            },
            "type": "playlist",
            "uri": "spotify:user:spotify:playlist:59ZbFPES4DQwEjBpWHzrtC"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var playlist: Playlist?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            playlist = try decoder.decode(Playlist.self, from: data)
        }  catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        print(playlist)
        XCTAssertNotNil(playlist)
    }
    
    static var allTests = [
        ("testAlbumDecoding", testAlbumDecoding),
    ]
}
