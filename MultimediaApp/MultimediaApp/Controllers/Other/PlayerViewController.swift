//
//  PlayerViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit
import SDWebImage

protocol PlayerDataSource: AnyObject {
    
    var trackName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
    
}

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapNext()
    func didTapBack()
    func didSlideVolume(_ value: Float)
}

class PlayerViewController: UIViewController {

    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
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
        Logger.log(object: Self.self, method: #function)
        view.backgroundColor = .systemBackground
        controlView.delegate = self
        view.addSubview(imageView)
        view.addSubview(controlView)
        configureBarButtons()
        configure()
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
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                           target: self, action: #selector(didTapAction))
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL,
                              placeholderImage: UIImage(systemName: "music.note"),
                              options: .lowPriority,
                              completed: nil)
        controlView.configure(with: PlayerControlsViewViewModel(title: dataSource?.trackName,
                                                                subtitle: dataSource?.subtitle))
    }
    
    public func refreshUI() {
        configure()
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
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapBack(_ playerControlsView: PlayerControlsView) {
        Logger.log(object: Self.self, method: #function)
        delegate?.didTapBack()
    }
    
    func playerControlsViewDidTapNext(_ playerControlsView: PlayerControlsView) {
        Logger.log(object: Self.self, method: #function)
        delegate?.didTapNext()
    }
    
    func playerControlsView(_ playerControlView: PlayerControlsView, didSlideWith volume: Float) {
        Logger.log(object: Self.self, method: #function)
        delegate?.didSlideVolume(volume)
    }
    
}
