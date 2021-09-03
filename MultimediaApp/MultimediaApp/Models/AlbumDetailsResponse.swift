//
//  AlbumDetailsResponse.swift
//  MultimediaApp
//
//  Created by developer on 03.08.2021.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: UserExternalURLS
    let href: String
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let popularity: Int
    let release_date: String
    let release_date_precision: String
    let total_tracks: Int
    let tracks: TracksResponse
    let type: String
    let uri: String
}

struct TracksResponse: Codable {
    let href: String
    let items: [AudioTrack]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
