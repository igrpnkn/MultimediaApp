//
//  NewReleasesRespone.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 30.07.2021.
//

import Foundation

struct NewReleasesRespone: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let href: String
    let items: [Album]
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
}

struct Album: Codable {
    let id: String
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: UserExternalURLS
    let href: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let release_date_precision: String
    let total_tracks: Int
    let type: String
    let uri: String
}
