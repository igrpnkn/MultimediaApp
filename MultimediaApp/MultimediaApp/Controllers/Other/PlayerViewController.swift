//
//  PlayerViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class PlayerViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note")
        imageView.tintColor = .secondaryLabel
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let controlView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        controlView.delegate = self
        view.addSubview(imageView)
        view.addSubview(controlView)
        configureBarButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 40,
                                 y: view.safeAreaInsets.top+20,
                                 width: view.width-80,
                                 height: view.width-80)
        controlView.frame = CGRect(x: 10,
                                 y: imageView.bottom+10,
                                 width: view.width-20,
                                 height: view.height-imageView.height-10)
    }
    
    func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                           target: self, action: #selector(didTapAction))
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapAction() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        Logger.log(object: Self.self, method: #function)
    }
    
    func playerControlsViewDidTapBack(_ playerControlsView: PlayerControlsView) {
        Logger.log(object: Self.self, method: #function)
    }
    
    func playerControlsViewDidTapNext(_ playerControlsView: PlayerControlsView) {
        Logger.log(object: Self.self, method: #function)
    }
    
}
