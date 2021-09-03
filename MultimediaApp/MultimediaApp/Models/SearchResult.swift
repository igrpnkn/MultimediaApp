//
//  SearchResult.swift
//  MultimediaApp
//
//  Created by developer on 06.08.2021.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
