//
//  PlaylistHeaderCollectionReusableView.swift
//  MultimediaApp
//
//  Created by developer on 04.08.2021.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    public static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private var isPlayingAll: Bool = false
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "opticaldisc")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .natural
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        label.numberOfLines = 4
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 1
        return label
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .spotifyGreen
        let image = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(coverImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height/1.8
        coverImageView.frame = CGRect(x: (width-imageSize)/2,
                                      y: 0,
                                      width: imageSize,
                                      height: imageSize)
        nameLabel.frame = CGRect(x: 15, y: coverImageView.bottom+20, width: width-30, height: 40)
        nameLabel.sizeToFit()
        descriptionLabel.frame = CGRect(x: 15, y: nameLabel.bottom+10, width: width-30, height: 80)
        descriptionLabel.sizeToFit()
        ownerLabel.frame = CGRect(x: 15, y: descriptionLabel.bottom+10, width: width-30, height: 20)
        playAllButton.frame = CGRect(x: width-68, y: height-58, width: 48, height: 48)
    }
    
    public func configure(with viewModel: PlaylistHeaderCollectionReusableViewViewModel) {
        self.nameLabel.text = viewModel.playlistName
        self.descriptionLabel.text = viewModel.description
        self.ownerLabel.text = viewModel.ownerName.localizedCapitalized
        self.coverImageView.sd_setImage(with: viewModel.artworkURL,
                                        placeholderImage: UIImage(systemName: "music.note.list"),
                                        options: .lowPriority,
                                        context: nil)
    }
    
    @objc
    private func didTapPlayAll() {
        if let delegate = delegate {
            delegate.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
            isPlayingAll = !isPlayingAll
            switch isPlayingAll {
            case true:
                self.playAllButton.setImage(UIImage(systemName: "pause.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                                   weight: .medium)),
                                            for: .normal)
                Logger.log(object: Self.self, method: #function)
                break
            case false:
                self.playAllButton.setImage(UIImage(systemName: "play.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                                   weight: .medium)),
                                            for: .normal)
                Logger.log(object: Self.self, method: #function)
                break
            }
            
        }
    }
    
}
