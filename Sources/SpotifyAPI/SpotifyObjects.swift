//
//  File.swift
//
//
//  Created by Ted Bennett on 25/09/2020.
//

import Foundation

struct Album: Codable {
    var albumType: String
    var artists: [ArtistSimplified]
    var availableMarkets: [String]
    var copyrights: [Copyright]
    var externalIds: ExternalId
    var externalUrls: ExternalUrl
    var genres: [String]
    var href: URL?
    var id: String
    var images: [Image]
    var label: String?
    var name: String
    var popularity: Int
    var releaseDate: String
    var releaseDatePrecision: String
    var tracks: Paging<TrackSimplified>
    var type: String
    var uri: String
}

struct AlbumSimplified: Codable {
    var albumGroup: String?
    var albumType: String
    var artists: [ArtistSimplified]?
    var availableMarkets: [String]
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var name: String
    var type: String
    var uri: String
}

struct Artist: Codable {
    var externalUrls: ExternalUrl
    var followers: Followers?
    var genres: [String]
    var href: URL?
    var id: String
    var images: [Image]
    var name: String
    var popularity: Int
    var type: String
    var uri: String
}

struct ArtistSimplified: Codable {
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var name: String
    var type: String
    var uri: String
}

struct AudioFeatures: Codable {
    var acousticness: Double
    var analysisUrl: String
    var danceability: Double
    var durationMs: Int
    var energy: Double
    var id: String
    var instrumentalness: Double
    var key: Int
    var liveness: Double
    var loudness: Double
    var mode: Int
    var speechiness: Double
    var tempo: Double
    var timeSignature: Int
    var trackHref: String
    var type: String
    var uri: String
    var valence: Double
}

struct CategoryObject: Codable {
    var href: URL?
    var icons: [Image]
    var id: String
    var name: String
}

struct Context: Codable {
    var type: String
    var href: URL?
    var externalUrls: ExternalUrl
    var uri: String
}

struct Copyright: Codable {
    var text: String
    var type: String
}

struct Cursor: Codable {
    var after: String
}

struct Device: Codable {
    var id: String
    var isActive: Bool
    var isPrivateSession: Bool
    var name: String
    var type: String
    var volumePercent: Int
}

struct Devices: Codable {
    var devices: [Device]
}

struct Disallows: Codable {
    var interruptingPlayback: Bool?
    var pausing: Bool?
    var resuming: Bool?
    var seeking: Bool?
    var skippingNext: Bool?
    var skippingPrev: Bool?
    var togglingRepeatContext: Bool?
    var togglingShuffle: Bool?
    var togglingRepeatTrack: Bool?
    var transferringPlayback: Bool?
}

struct Episode: Codable {
    var audioPreviewUrl: String
    var description: String
    var durationMs: Int
    var explicit: Bool
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var isExternallyHosted: Bool
    var isPlayable: Bool
    var language: String
    var languages: [String]
    var name: String
    var releaseDate: String
    var releaseDatePrecision: String
    var resumePoint: ResumePoint
    var show: ShowSimplified
    var type: String
    var uri: String
}

struct EpisodeSimplified: Codable {
    var audioPreviewUrl: String
    var description: String
    var durationMs: Int
    var explicit: Bool?
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var isExternallyHosted: Bool
    var isPlayable: Bool?
    var language: String
    var languages: [String]?
    var name: String
    var releaseDate: String
    var releaseDatePrecision: String
    var resumePoint: ResumePoint?
    var type: String
    var uri: String
}

struct SpotifyError: Codable {
    var status: Int
    var message: String
}

struct PlayerError: Codable {
    var status: Int
    var message: String
    var reason: String
}

enum PlayerErrorReasons: String {
    case noPrevTrack = "NO_PREV_TRACK"
    case noNextTrack = "NO_NEXT_TRACK"
    case noSpecificTrack = "NO_SPECIFIC_TRACK"
    case alreadyPaused = "ALREADY_PAUSED"
    case notPaused = "NOT_PAUSED"
    case notPlayingLocally = "NOT_PLAYING_LOCALLY"
    case notPlayingTrack = "NOT_PLAYING_TRACK"
    case notPlayingContext = "NOT_PLAYING_CONTEXT"
    case endlessContext = "ENDLESS_CONTEXT"
    case contextDisallow = "CONTEXT_DISALLOW"
    case alreadyPlaying = "ALREADY_PLAYING"
    case rateLimited = "RATE_LIMITED"
    case remoteControlDisallow = "REMOTE_CONTROL_DISALLOW"
    case deviceNotControllable = "DEVICE_NOT_CONTROLLABLE"
    case volumeControlDisallow = "VOLUME_CONTROL_DISALLOW"
    case noActiveDevice = "NO_ACTIVE_DEVICE"
    case premiumRequired = "PREMIUM_REQUIRED"
    case unknown = "UNKNOWN"
}

struct ExternalId: Codable {
    var isrc: String?
    var ean: String?
    var upc: String?
}

struct ExternalUrl: Codable {
    var spotify: String?
}

struct Followers: Codable {
    var href: URL?
    var total: Int
}

struct Image: Codable {
    var height: Int?
    var url: String
    var width: Int?
}

struct Paging<Object: Codable>: Codable {
    var href: URL?
    var items: [Object]
    var limit: Int
    var next: URL?
    var offset: Int
    var previous: URL?
    var total: Int
}

struct PagingCursor<Object: Codable>: Codable {
    var href: URL?
    var items: [Object]
    var limit: Int
    var next: String?
    var cursors: Cursor
    var total: Int
}

struct PlayHistory: Codable {
    var track: TrackSimplified
    var playedAt: String
    var context: Context
}

struct PlaylistSimplified: Codable {
    var collaborative: Bool
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var name: String
    var owner: UserPublic
    var isPublic: Bool?
    var snapshotId: String
    var tracks: PlaylistTracks
    var type: String
    var uri: String
    
    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case externalUrls, snapshotId, collaborative, href, id, images, name, owner, tracks, type, uri
    }
}

struct Playlist: Codable {
    var collaborative: Bool
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var name: String
    var owner: UserPublic
    var isPublic: Bool?
    var snapshotId: String
    var tracks: Paging<PlaylistTrack>
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case externalUrls, snapshotId, collaborative, href, id, images, name, owner, tracks, type, uri
    }
}

struct PlaylistTrack: Codable {
    var addedAt: String
    var addedBy: UserPublic
    var isLocal: Bool
    var track: Track
}

struct PlaylistTracks: Codable {
    var href: URL?
    var total: Int
}

struct Recommendations: Codable {
    var seeds: [RecommendationsSeed]
    var tracks: [TrackSimplified]
}

struct RecommendationsSeed: Codable {
    var afterFilteringSize: Int
    var afterRelinkingSize: Int
    var href: URL?
    var id: String
    var initialPoolSize: Int
    var type: String
}

struct ResumePoint: Codable {
    var fullyPlayed: Bool
    var resumePositionMs: Int
}

struct SavedTrack {
    var addedAt: String
    var track: Track
}

struct SavedAlbum {
    var addedAt: String
    var album: Album
}

struct SavedShow {
    var addedAt: String
    var show: Show
}

struct Show: Codable {
    var availableMarkets: [String]
    var copyrights: [Copyright]
    var description: String
    var explicit: Bool?
    var episodes: Paging<EpisodeSimplified>
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var isExternallyHosted: Bool
    var languages: [String]
    var mediaType: String
    var name: String
    var publisher: String
    var type: String
    var uri: String
}

struct ShowSimplified: Codable {
    var availableMarkets: [String]
    var copyrights: [Copyright]
    var description: String
    var explicit: Bool
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var images: [Image]
    var isExternallyHosted: Bool
    var languages: [String]
    var mediaType: String
    var name: String
    var publisher: String
    var type: String
    var uri: String
}

struct Track: Codable {
    var album: AlbumSimplified
    var artists: [ArtistSimplified]
    var availableMarkets: [String]
    var discNumber: Int
    var durationMs: Int
    var explicit: Bool
    var externalIds: ExternalId
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var isPlayable: Bool?
    var linkedFrom: TrackLink?
    var name: String
    var popularity: Int
    var previewUrl: URL?
    var trackNumber: Int
    var type: String
    var uri: String
}

struct TrackSimplified: Codable {
    var artists: [ArtistSimplified]
    var availableMarkets: [String]
    var discNumber: Int
    var durationMs: Int
    var explicit: Bool
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var isPlayable: Bool?
    var linkedFrom: TrackLink?
    var name: String
    var previewUrl: String
    var trackNumber: Int
    var type: String
    var uri: String
}

struct TrackLink: Codable {
    var externalUrls: ExternalUrl
    var href: URL?
    var id: String
    var type: String
    var uri: String
}

struct UserPrivate: Codable {
    var country: String
    var displayName: String
    var email: String
    var externalUrls: ExternalUrl
    var followers: Followers
    var href: URL?
    var id: String
    var images: [Image]
    var product: String
    var type: String
    var uri: String
}

struct UserPublic: Codable {
    var displayName: String?
    var externalUrls: ExternalUrl
    var followers: Followers?
    var href: URL?
    var id: String
    var images: [Image]?
    var type: String
    var uri: String
}
