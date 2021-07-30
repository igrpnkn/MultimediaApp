//
//  Artist.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

struct Artist: Codable {
    let id: String
    let external_urls: UserExternalURLS
    let href: String
    let name: String
    let type: String
    let uri: String
}
