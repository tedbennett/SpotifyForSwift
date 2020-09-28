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
        
        XCTAssertNotNil(playlist)
    }
    
    func testShowDecoding() {
        let json = """
                  {
          "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IL", "IS", "IT", "JP", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "RO", "SE", "SG", "SK", "SV", "TH", "TR", "TW", "US", "UY", "VN", "ZA" ],
          "copyrights" : [ ],
          "description" : "Vi är där historien är. Ansvarig utgivare: Nina Glans",
          "episodes" : {
            "href" : "https://api.spotify.com/v1/shows/38bS44xjbVVZ3No3ByF1dJ/episodes?offset=0&limit=50",
            "items" : [ {
              "audio_preview_url" : "https://p.scdn.co/mp3-preview/7a785904a33e34b0b2bd382c82fca16be7060c36",
              "description" : "Hör Tobias Svanelid och hans bok- och spelpaneler tipsa om de bästa historiska böckerna och spelen att njuta av i sommar!  Hör Vetenskapsradion Historias Tobias Svanelid tipsa tillsammans med Kristina Ekero Eriksson och Urban Björstadius om de bästa böckerna att ta med till hängmattan i sommar. Något för alla utlovas  såsom stormande 1700-talskärlek, seglivade småfolk och kvinnliga bågskyttar under korstågen. Dessutom tipsas om två historiska brädspel, där spelarna i det ena förflyttas till medeltidens Orléans, i det andra ska överleva på Robinson Kruses öde ö, bland annat genom att tillaga tigerstek! De böcker som nämns i programmet är: Völvor, krigare och vanligt folk av Kent Andersson Kvinnliga krigare av Stefan Högberg De små folkens historia av Ingmar Karlsson Jugoslaviens undergång av Sanimir Resic Venedig: En vägvisare i tid och rum av Carin Norberg och Carl Tham Samlare, jägare och andra fågelskådare av Susanne Nylund Skog Ebba Hochschild: Att leva efter döden av Caroline Ranby 68 av Henrik Berggren Förnuft eller känsla av Brita Planck Finanskrascher av Lars Magnusson   Spelen som testas är: Orléans av Reiner Stockhausen Robinson Crusoe - Adventures on the Cursed Island av Ignazy Trzewiczek",
              "duration_ms" : 2677448,
              "external_urls" : {
                "spotify" : "https://open.spotify.com/episode/4d237GqKH4NP1jtgwy6bP3"
              },
              "href" : "https://api.spotify.com/v1/episodes/4d237GqKH4NP1jtgwy6bP3",
              "id" : "4d237GqKH4NP1jtgwy6bP3",
              "images" : [ {
                "height" : 640,
                "url" : "https://i.scdn.co/image/606eba074860660c91819636bcb5e141ddf4e23d",
                "width" : 640
              }, {
                "height" : 300,
                "url" : "https://i.scdn.co/image/245062bc785bb8672cd002cb96b518a4f50e9067",
                "width" : 300
              }, {
                "height" : 64,
                "url" : "https://i.scdn.co/image/cc0797a99e21733caf0f4e23685a173033fdaa49",
                "width" : 64
              } ],
              "is_externally_hosted" : false,
              "language" : "sv",
              "name" : "Pyttefolk och tigerstekar i hängmattan",
              "release_date" : "2018-06-19",
              "release_date_precision" : "day",
              "type" : "episode",
              "uri" : "spotify:episode:4d237GqKH4NP1jtgwy6bP3"
            }, {
              "audio_preview_url" : "https://p.scdn.co/mp3-preview/99180ec43a984c61b079bd3e71443a1886d0290c",
              "description" : "Tobias Svanelid besöker den svenska arkeologiska expeditionen på Cypern där man nu söker efter svaret på vad som drabbade bronsåldersstäderna för 3000 år sedan och orsakade bronsålderns kollaps.  - Det är som att jobba som Indiana Jones, berättar Alfred Sjelvgren som är en av arkeologerna som gräver på platsen. I Hala Sultan Tekke vid Larnaca på Cypern har svenska arkeologer under ledning av Peter Fischer grävt sedan 2010. Det de hittat är en av bronsålderns största och rikaste städer, där brons och purpurfärgade textilier en gång exporterades runt Medelhavet och ända upp till Sverige för drygt 3000 år sedan. Men den rika handelsstadens öde blev våldsamt. I likhet med så många andra Medelhavsstäder gick Hala Sultan Tekke under i en våldsam händelse som beskrivits som bronsålderns kollaps och kanske kan fynden från utgrävningen ge svar på vad som hände. - Jag tror att det är en kombination av bidragande orsaker som orsakade kollapsen, menar Peter Fischer, arkeologiprofessor vid Göteborgs universitet. Klimatförändringar, revolutioner och folkvandringar gjorde att många av bronsålderns högkulturer, inklusive den på Cypern, gick under.",
              "duration_ms" : 2666659,
              "explicit" : false,
              "external_urls" : {
                "spotify" : "https://open.spotify.com/episode/4nLBHCqEvCcRyWImnKo009"
              },
              "href" : "https://api.spotify.com/v1/episodes/4nLBHCqEvCcRyWImnKo009",
              "id" : "4nLBHCqEvCcRyWImnKo009",
              "images" : [ {
                "height" : 640,
                "url" : "https://i.scdn.co/image/80a842ffc3d0c5fc1ec69e3e4987a99052454f26",
                "width" : 640
              }, {
                "height" : 300,
                "url" : "https://i.scdn.co/image/3a2ca33937fcef64124f492b6bd67d3583f1278e",
                "width" : 300
              }, {
                "height" : 64,
                "url" : "https://i.scdn.co/image/fe428e98ad84732dff1ea73ae7f3fae5110e658c",
                "width" : 64
              } ],
              "is_externally_hosted" : false,
              "is_playable" : true,
              "language" : "sv",
              "languages" : [ "sv" ],
              "name" : "Bronsåldersstadens kollaps",
              "release_date" : "2018-06-12",
              "release_date_precision" : "day",
              "type" : "episode",
              "uri" : "spotify:episode:4nLBHCqEvCcRyWImnKo009"
            } ],
            "limit" : 50,
            "next" : "https://api.spotify.com/v1/shows/38bS44xjbVVZ3No3ByF1dJ/episodes?offset=50&limit=50",
            "offset" : 0,
            "previous" : null,
            "total" : 520
          },
          "explicit" : false,
          "external_urls" : {
            "spotify" : "https://open.spotify.com/show/38bS44xjbVVZ3No3ByF1dJ"
          },
          "href" : "https://api.spotify.com/v1/shows/38bS44xjbVVZ3No3ByF1dJ",
          "id" : "38bS44xjbVVZ3No3ByF1dJ",
          "images" : [ {
            "height" : 640,
            "url" : "https://i.scdn.co/image/3c59a8b611000c8b10c8013013c3783dfb87a3bc",
            "width" : 640
          }, {
            "height" : 300,
            "url" : "https://i.scdn.co/image/2d70c06ac70d8c6144c94cabf7f4abcf85c4b7e4",
            "width" : 300
          }, {
            "height" : 64,
            "url" : "https://i.scdn.co/image/3dc007829bc0663c24089e46743a9f4ae15e65f8",
            "width" : 64
          } ],
          "is_externally_hosted" : false,
          "languages" : [ "sv" ],
          "media_type" : "audio",
          "name" : "Vetenskapsradion Historia",
          "publisher" : "Sveriges Radio",
          "type" : "show",
          "uri" : "spotify:show:38bS44xjbVVZ3No3ByF1dJ"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var show: Show?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            show = try decoder.decode(Show.self, from: data)
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
        
        XCTAssertNotNil(show)
    }
    
    func testTrackDecoding() {
        let json = """
        {
            "album": {
                "album_type": "single",
                "artists": [
                    {
                        "external_urls": {
                            "spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
                        },
                        "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
                        "id": "6sFIWsNpZYqfjUpaCgueju",
                        "name": "Carly Rae Jepsen",
                        "type": "artist",
                        "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
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
                    "CA",
                    "CH",
                    "CL",
                    "CO",
                    "CR",
                    "CY",
                    "CZ",
                    "DE",
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
                    "ID",
                    "IE",
                    "IL",
                    "IS",
                    "IT",
                    "JP",
                    "LI",
                    "LT",
                    "LU",
                    "LV",
                    "MC",
                    "MT",
                    "MX",
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
                    "SK",
                    "SV",
                    "TH",
                    "TR",
                    "TW",
                    "US",
                    "UY",
                    "VN",
                    "ZA"
                ],
                "external_urls": {
                    "spotify": "https://open.spotify.com/album/0tGPJ0bkWOUmH7MEOR77qc"
                },
                "href": "https://api.spotify.com/v1/albums/0tGPJ0bkWOUmH7MEOR77qc",
                "id": "0tGPJ0bkWOUmH7MEOR77qc",
                "images": [
                    {
                        "height": 640,
                        "url": "https://i.scdn.co/image/966ade7a8c43b72faa53822b74a899c675aaafee",
                        "width": 640
                    },
                    {
                        "height": 300,
                        "url": "https://i.scdn.co/image/107819f5dc557d5d0a4b216781c6ec1b2f3c5ab2",
                        "width": 300
                    },
                    {
                        "height": 64,
                        "url": "https://i.scdn.co/image/5a73a056d0af707b4119a883d87285feda543fbb",
                        "width": 64
                    }
                ],
                "name": "Cut To The Feeling",
                "release_date": "2017-05-26",
                "release_date_precision": "day",
                "type": "album",
                "uri": "spotify:album:0tGPJ0bkWOUmH7MEOR77qc"
            },
            "artists": [
                {
                    "external_urls": {
                        "spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
                    },
                    "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
                    "id": "6sFIWsNpZYqfjUpaCgueju",
                    "name": "Carly Rae Jepsen",
                    "type": "artist",
                    "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
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
                "CA",
                "CH",
                "CL",
                "CO",
                "CR",
                "CY",
                "CZ",
                "DE",
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
                "ID",
                "IE",
                "IL",
                "IS",
                "IT",
                "JP",
                "LI",
                "LT",
                "LU",
                "LV",
                "MC",
                "MT",
                "MX",
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
                "SK",
                "SV",
                "TH",
                "TR",
                "TW",
                "US",
                "UY",
                "VN",
                "ZA"
            ],
            "disc_number": 1,
            "duration_ms": 207959,
            "explicit": false,
            "external_ids": {
                "isrc": "USUM71703861"
            },
            "external_urls": {
                "spotify": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl"
            },
            "href": "https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl",
            "id": "11dFghVXANMlKmJXsNCbNl",
            "is_local": false,
            "name": "Cut To The Feeling",
            "popularity": 63,
            "preview_url": "https://p.scdn.co/mp3-preview/3eb16018c2a700240e9dfb8817b6f2d041f15eb1?cid=774b29d4f13844c495f206cafdad9c86",
            "track_number": 1,
            "type": "track",
            "uri": "spotify:track:11dFghVXANMlKmJXsNCbNl"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var track: Track?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            track = try decoder.decode(Track.self, from: data)
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
        
        XCTAssertNotNil(track)
    }
    
    func testAudioFeaturesDecoding() {
        let json = """
        {
            "danceability": 0.735,
            "energy": 0.578,
            "key": 5,
            "loudness": -11.84,
            "mode": 0,
            "speechiness": 0.0461,
            "acousticness": 0.514,
            "instrumentalness": 0.0902,
            "liveness": 0.159,
            "valence": 0.624,
            "tempo": 98.002,
            "type": "audio_features",
            "id": "06AKEBrKUckW0KREUWRnvT",
            "uri": "spotify:track:06AKEBrKUckW0KREUWRnvT",
            "track_href": "https://api.spotify.com/v1/tracks/06AKEBrKUckW0KREUWRnvT",
            "analysis_url": "https://api.spotify.com/v1/audio-analysis/06AKEBrKUckW0KREUWRnvT",
            "duration_ms": 255349,
            "time_signature": 4
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var audioFeatures: AudioFeatures?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            audioFeatures = try decoder.decode(AudioFeatures.self, from: data)
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
        
        XCTAssertNotNil(audioFeatures)
    }
    
    func testCategoryDecoding() {
        let json = """
        {
          "href" : "https://api.spotify.com/v1/browse/categories/party",
          "icons" : [ {
            "height" : 274,
            "url" : "https://datsnxq1rwndn.cloudfront.net/media/derived/party-274x274_73d1907a7371c3bb96a288390a96ee27_0_0_274_274.jpg",
            "width" : 274
          } ],
          "id" : "party",
          "name" : "Party"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var category: CategoryObject?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            category = try decoder.decode(CategoryObject.self, from: data)
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
        
        XCTAssertNotNil(category)
    }
    
    func testUserDecoding() {
        let json = """
        {
            "display_name": "Lilla Namo",
            "external_urls": {
                "spotify": "https://open.spotify.com/user/tuggareutangranser"
            },
            "followers": {
                "href": null,
                "total": 4561
            },
            "href": "https://api.spotify.com/v1/users/tuggareutangranser",
            "id": "tuggareutangranser",
            "images": [
                {
                    "height": null,
                    "url": "http://profile-images.scdn.co/artists/default/d4f208d4d49c6f3e1363765597d10c4277f5b74f",
                    "width": null
                }
            ],
            "type": "user",
            "uri": "spotify:user:tuggareutangranser"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var user: UserPublic?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            user = try decoder.decode(UserPublic.self, from: data)
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
        
        XCTAssertNotNil(user)
    }
    
    func testUserPrivateDecoding() {
        let json = """
        {
            "country": "SE",
            "display_name": "JM Wizzler",
            "email": "email@example.com",
            "external_urls": {
                "spotify": "https://open.spotify.com/user/wizzler"
            },
            "followers": {
                "href": null,
                "total": 3829
            },
            "href": "https://api.spotify.com/v1/users/wizzler",
            "id": "wizzler",
            "images": [
                {
                    "height": null,
                    "url": "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/1970403_10152215092574354_1798272330_n.jpg",
                    "width": null
                }
            ],
            "product": "premium",
            "type": "user",
            "uri": "spotify:user:wizzler"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        var user: UserPrivate?
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            user = try decoder.decode(UserPrivate.self, from: data)
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
        
        XCTAssertNotNil(user)
    }
    
    static var allTests = [
        ("testAlbumDecoding", testAlbumDecoding),
    ]
}
