//
//  RecommendationsResponse.swift
//  MultimediaApp
//
//  Created by developer on 30.07.2021.
//

import Foundation

struct RecommendationsResponse: Codable {
//    let seeds: []
    let tracks: [AudioTrack]
}
