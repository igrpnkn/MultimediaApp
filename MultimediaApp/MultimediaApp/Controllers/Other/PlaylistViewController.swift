//
//  PlaylistViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: Playlist
    
    init(with playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        fetchData ()
    }

}

// MARK: - Fetching Data from API

extension PlaylistViewController {
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getPlaylistDetails(for: self.playlist) { (result) in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
