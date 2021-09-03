//
//  LibraryPlaylistsResponse.swift
//  MultimediaApp
//
//  Created by developer on 26.08.2021.
//

import Foundation

struct LibraryPlaylistsResponse: Codable {
    let href: String
    let items: [Playlist]
    let limit: Int
    let next: Int?
    let offset: Int
    let total: Int
}
