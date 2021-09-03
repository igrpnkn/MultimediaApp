//
//  LibraryToggleView.swift
//  MultimediaApp
//
//  Created by developer on 24.08.2021.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView:LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView:LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    public var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .spotifyGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistsButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        albumsButton.frame = CGRect(x: playlistsButton.right, y: 0, width: 100, height: 50)
        layoutStateIndicator()
    }
    
    private func layoutStateIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: playlistsButton.left, y: playlistsButton.bottom, width: 100, height: 5)
        case .album:
            indicatorView.frame = CGRect(x: albumsButton.left, y: albumsButton.bottom, width: 100, height: 5)
        }
    }
    
    @objc
    private func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.3) {
            self.layoutStateIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc
    private func didTapAlbums() {
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutStateIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    public func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutStateIndicator()
        }
    }
    
}

