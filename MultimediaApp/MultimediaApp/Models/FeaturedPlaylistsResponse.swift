//
//  FeaturedPlaylistsResponse.swift
//  MultimediaApp
//
//  Created by developer on 30.07.2021.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let message: String
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let href: String
    let items: [Playlist]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
