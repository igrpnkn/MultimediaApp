//
//  UserProfile.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: UserExplicitContent
    let external_urls: UserExternalURLS
    let followers: UserFollowers
    let href: String
    let id: String
    let product: String
    let type: String
    let uri: String
    let images: [UserImage?]
}

struct UserImage: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

struct UserFollowers: Codable {
    let href: String?
    let total: Int?
}

struct UserExplicitContent: Codable {
    let filter_enabled: Bool
    let filter_locked: Bool
}

struct UserExternalURLS: Codable {
    let spotify: String?
}
