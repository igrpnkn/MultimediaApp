//
//  LibraryAlbumsResponse.swift
//  MultimediaApp
//
//  Created by developer on 02.09.2021.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [LibrarySavedAlbum]
}

struct LibrarySavedAlbum: Codable {
    let added_at: String
    let album: Album
}

