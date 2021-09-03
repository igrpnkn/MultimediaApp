//
//  Audiotrack.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_ids: [String: String]?
    let external_urls: UserExternalURLS
    let href: String
    let id: String
    let is_local: Bool
    let name: String
    let popularity: Int?
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
}

struct AudioTracks: Codable {
    let tracks: [AudioTrack]
}
