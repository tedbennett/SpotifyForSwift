//
//  File.swift
//
//
//  Created by Ted Bennett on 25/09/2020.
//

import Foundation

public struct Album: Codable, Identifiable {
    public var albumType: String
    public var artists: [ArtistSimplified]
    public var availableMarkets: [String]
    public var copyrights: [Copyright]
    public var externalIds: ExternalId
    public var externalUrls: ExternalUrl
    public var genres: [String]
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var label: String?
    public var name: String
    public var popularity: Int
    public var releaseDate: String
    public var releaseDatePrecision: String
    public var tracks: Paging<TrackSimplified>
    public var type: String
    public var uri: String
}

public struct AlbumSimplified: Codable, Identifiable {
    public var albumGroup: String?
    public var albumType: String
    public var artists: [ArtistSimplified]?
    public var availableMarkets: [String]?
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var name: String
    public var type: String
    public var uri: String
}

public struct Artist: Codable, Identifiable {
    public var externalUrls: ExternalUrl
    public var followers: Followers?
    public var genres: [String]
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var name: String
    public var popularity: Int
    public var type: String
    public var uri: String
}

public struct ArtistSimplified: Codable, Identifiable {
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var name: String
    public var type: String
    public var uri: String
}

public struct AudioFeatures: Codable, Identifiable {
    public var acousticness: Double
    public var analysisUrl: String
    public var danceability: Double
    public var durationMs: Int
    public var energy: Double
    public var id: String
    public var instrumentalness: Double
    public var key: Int
    public var liveness: Double
    public var loudness: Double
    public var mode: Int
    public var speechiness: Double
    public var tempo: Double
    public var timeSignature: Int
    public var trackHref: String
    public var type: String
    public var uri: String
    public var valence: Double
}

public struct CategoryObject: Codable, Identifiable {
    public var href: URL?
    public var icons: [Image]
    public var id: String
    public var name: String
}

public struct Context: Codable {
    public var type: String
    public var href: URL?
    public var externalUrls: ExternalUrl
    public var uri: String
}

public struct Copyright: Codable {
    public var text: String
    public var type: String
}

public struct Cursor: Codable {
    public var after: String
}

public struct Device: Codable, Identifiable {
    public var id: String
    public var isActive: Bool
    public var isPrivateSession: Bool
    public var name: String
    public var type: String
    public var volumePercent: Int
}

public struct Devices: Codable {
    public var devices: [Device]
}

public struct Disallows: Codable {
    public var interruptingPlayback: Bool?
    public var pausing: Bool?
    public var resuming: Bool?
    public var seeking: Bool?
    public var skippingNext: Bool?
    public var skippingPrev: Bool?
    public var togglingRepeatContext: Bool?
    public var togglingShuffle: Bool?
    public var togglingRepeatTrack: Bool?
    public var transferringPlayback: Bool?
}

public struct Episode: Codable, Identifiable {
    public var audioPreviewUrl: String
    public var description: String
    public var durationMs: Int
    public var explicit: Bool
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var isExternallyHosted: Bool
    public var isPlayable: Bool
    public var language: String
    public var languages: [String]
    public var name: String
    public var releaseDate: String
    public var releaseDatePrecision: String
    public var resumePoint: ResumePoint
    public var show: ShowSimplified
    public var type: String
    public var uri: String
}

public struct EpisodeSimplified: Codable, Identifiable {
    public var audioPreviewUrl: String
    public var description: String
    public var durationMs: Int
    public var explicit: Bool?
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var isExternallyHosted: Bool
    public var isPlayable: Bool?
    public var language: String
    public var languages: [String]?
    public var name: String
    public var releaseDate: String
    public var releaseDatePrecision: String
    public var resumePoint: ResumePoint?
    public var type: String
    public var uri: String
}

public struct SpotifyError: Codable {
    public var status: Int
    public var message: String
}

public struct PlayerError: Codable {
    public var status: Int
    public var message: String
    public var reason: String
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

public struct ExternalId: Codable {
    public var isrc: String?
    public var ean: String?
    public var upc: String?
}

public struct ExternalUrl: Codable {
    public var spotify: String?
}

public struct Followers: Codable {
    public var href: URL?
    public var total: Int
}

public struct Image: Codable {
    public var height: Int?
    public var url: String
    public var width: Int?
}

public struct Paging<Object: Codable>: Codable {
    public var href: URL?
    public var items: [Object]
    public var limit: Int
    public var next: URL?
    public var offset: Int
    public var previous: URL?
    public var total: Int
}

public struct PagingCursor<Object: Codable>: Codable {
    public var href: URL?
    public var items: [Object]
    public var limit: Int
    public var next: String?
    public var cursors: Cursor
    public var total: Int
}

public struct PlayHistory: Codable {
    public var track: TrackSimplified
    public var playedAt: String
    public var context: Context
}

public struct PlaylistSimplified: Codable, Identifiable {
    public var collaborative: Bool
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var name: String
    public var owner: UserPublic
    public var isPublic: Bool?
    public var snapshotId: String
    public var tracks: PlaylistTracks
    public var type: String
    public var uri: String
    
    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case externalUrls, snapshotId, collaborative, href, id, images, name, owner, tracks, type, uri
    }
}

public struct Playlist: Codable, Identifiable {
    public var collaborative: Bool
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var name: String
    public var owner: UserPublic
    public var isPublic: Bool?
    public var snapshotId: String
    public var tracks: Paging<PlaylistTrackWrapper>
    public var type: String
    public var uri: String

    enum CodingKeys: String, CodingKey {
        case isPublic = "public"
        case externalUrls, snapshotId, collaborative, href, id, images, name, owner, tracks, type, uri
    }
}

public struct PlaylistTrackWrapper: Codable {
    public var addedAt: String
    public var addedBy: UserPublic
    public var isLocal: Bool
    public var track: PlaylistTrack
}

public struct PlaylistTrack: Codable, Identifiable {
    public var album: PlaylistAlbum?
    public var artists: [PlaylistArtist]?
    public var availableMarkets: [String]?
    public var discNumber: Int?
    public var durationMs: Int?
    public var explicit: Bool?
    public var externalIds: ExternalId?
    public var externalUrls: ExternalUrl?
    public var href: URL?
    public var id: String?
    public var isPlayable: Bool?
    public var linkedFrom: TrackLink?
    public var name: String
    public var popularity: Int?
    public var previewUrl: URL?
    public var trackNumber: Int?
    public var type: String
    public var uri: String
}

public struct PlaylistAlbum: Codable, Identifiable {
    public var albumGroup: String?
    public var albumType: String?
    public var artists: [ArtistSimplified]?
    public var availableMarkets: [String]?
    public var externalUrls: ExternalUrl?
    public var href: URL?
    public var id: String?
    public var images: [Image]
    public var name: String
    public var type: String
    public var uri: String?
}

public struct PlaylistArtist: Codable, Identifiable {
    public var externalUrls: ExternalUrl?
    public var href: URL?
    public var id: String?
    public var name: String
    public var type: String
    public var uri: String?
}

public struct PlaylistTracks: Codable {
    public var href: URL?
    public var total: Int
}

public struct Recommendations: Codable {
    public var seeds: [RecommendationsSeed]
    public var tracks: [TrackSimplified]
}

public struct RecommendationsSeed: Codable, Identifiable {
    public var afterFilteringSize: Int
    public var afterRelinkingSize: Int
    public var href: URL?
    public var id: String
    public var initialPoolSize: Int
    public var type: String
}

public struct ResumePoint: Codable {
    public var fullyPlayed: Bool
    public var resumePositionMs: Int
}

public struct SavedTrack: Codable {
    public var addedAt: String
    public var track: Track
}

public struct SavedAlbum: Codable {
    public var addedAt: String
    public var album: Album
}

public struct SavedShow: Codable {
    public var addedAt: String
    public var show: Show
}

public struct Show: Codable, Identifiable {
    public var availableMarkets: [String]
    public var copyrights: [Copyright]
    public var description: String
    public var explicit: Bool?
    public var episodes: Paging<EpisodeSimplified>
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var isExternallyHosted: Bool
    public var languages: [String]
    public var mediaType: String
    public var name: String
    public var publisher: String
    public var type: String
    public var uri: String
}

public struct ShowSimplified: Codable, Identifiable {
    public var availableMarkets: [String]
    public var copyrights: [Copyright]
    public var description: String
    public var explicit: Bool
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var isExternallyHosted: Bool
    public var languages: [String]
    public var mediaType: String
    public var name: String
    public var publisher: String
    public var type: String
    public var uri: String
}

public struct Track: Codable, Identifiable {
    public var album: AlbumSimplified
    public var artists: [ArtistSimplified]
    public var availableMarkets: [String]?
    public var discNumber: Int?
    public var durationMs: Int
    public var explicit: Bool
    public var externalIds: ExternalId
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var isPlayable: Bool?
    public var linkedFrom: TrackLink?
    public var name: String
    public var popularity: Int
    public var previewUrl: URL?
    public var trackNumber: Int
    public var type: String
    public var uri: String
}

public struct TrackSimplified: Codable, Identifiable {
    public var artists: [ArtistSimplified]
    public var availableMarkets: [String]
    public var discNumber: Int
    public var durationMs: Int
    public var explicit: Bool
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var isPlayable: Bool?
    public var linkedFrom: TrackLink?
    public var name: String
    public var previewUrl: String?
    public var trackNumber: Int
    public var type: String
    public var uri: String
}

public struct TrackLink: Codable, Identifiable {
    public var externalUrls: ExternalUrl
    public var href: URL?
    public var id: String
    public var type: String
    public var uri: String
}

public struct UserPrivate: Codable, Identifiable {
    public var country: String
    public var displayName: String
    public var email: String
    public var externalUrls: ExternalUrl
    public var followers: Followers
    public var href: URL?
    public var id: String
    public var images: [Image]
    public var product: String
    public var type: String
    public var uri: String
}

public struct UserPublic: Codable, Identifiable {
    public var displayName: String?
    public var externalUrls: ExternalUrl
    public var followers: Followers?
    public var href: URL?
    public var id: String
    public var images: [Image]?
    public var type: String
    public var uri: String
}
