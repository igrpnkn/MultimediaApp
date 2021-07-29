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
}

struct Album: Codable {
    let album_type: String
}
