//
//  AllCategoriesResponse.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: AllCategories
}

struct AllCategories: Codable {
    let href: String
    let items: [CategoryItem]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct CategoryItem: Codable {
    let href: String
    let id: String
    let name: String
    let icons: [APIImage]
}
