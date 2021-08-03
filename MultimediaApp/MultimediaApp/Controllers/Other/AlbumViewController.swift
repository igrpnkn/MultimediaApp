//
//  AlbumViewController.swift
//  MultimediaApp
//
//  Created by developer on 03.08.2021.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    init(with album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = album.name
        view.backgroundColor = .systemBackground
        fetchData ()
    }
    
    

}

// MARK: - Fetching Data from API

extension AlbumViewController {
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getAlbumDetails(for: self.album) { (result) in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
}
