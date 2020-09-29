//
//  File.swift
//  
//
//  Created by Ted Bennett on 26/09/2020.
//

import Foundation

let baseUrl = URL(string: "https://api.spotify.com/v1/")!
let authUrl = URL(string: "https://accounts.spotify.com/authorize")!
let tokenUrl = URL(string: "https://accounts.spotify.com/api/token")!


enum Endpoints: String {
    case albums
    case artists
    case browse
    case recommendations
    case episodes
    case me
    case users
    case search
    case shows
    case tracks
    case playlists
    case audioFeatures = "audio-features"
    case topTracks = "top-tracks"
    case relatedArtists = "related-artists"
    
    static subscript(_ endpoint: Endpoints) -> String {
        return endpoint.rawValue
    }
}

enum AuthScope: String {
    case ugcImageUpload = "ugc-image-upload"
    case userReadPlaybackState = "user-read-playback-state"
    case userModifyPlaybackState = "user-modify-playback-state"
    case userReadCurrentlyPlaying = "user-read-currently-playing"
    case streaming = "streaming"
    case appRemoteControl = "app-remote-control"
    case userReadEmail = "user-read-email"
    case userReadPrivate = "user-read-private"
    case playlistReadCollaborativeCase = "playlist-read-collaborative"
    case playlistModifyPublic = "playlist-modify-public"
    case playlistReadPrivate = "playlist-read-private"
    case playlistModifyPrivate = "playlist-modify-private"
    case userLibraryModify = "user-library-modify"
    case userLibraryRead = "user-library-read"
    case userTopRead = "user-top-read"
    case userReadPlaybackPosition = "user-read-playback-position"
    case userReadRecentlyPlayed = "user-read-recently-played"
    case userFollowRead = "user-follow-read"
    case userFollowModify = "user-follow-modify"
}
