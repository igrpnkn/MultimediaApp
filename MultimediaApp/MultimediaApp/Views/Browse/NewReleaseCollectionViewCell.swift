//
//  NewReleaseCollectionViewCell.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 01.08.2021.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let albumLabel = UILabel()
        albumLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        albumLabel.numberOfLines = 1
        return albumLabel
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let numberOfTracksLabel = UILabel()
        numberOfTracksLabel.font = .systemFont(ofSize: 10, weight: .regular)
        numberOfTracksLabel.numberOfLines = 1
        return numberOfTracksLabel
    }()
    
    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        artistNameLabel.numberOfLines = 1
        return artistNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.mainColors.randomElement()?.withAlphaComponent(0.3)
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        let imageSize: CGFloat = contentView.height - 10
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width:  contentView.width-imageSize-20,
                                                                height: contentView.height-60))
        albumCoverImageView.frame = CGRect(x: 5,
                                           y: 5,
                                           width: imageSize,
                                           height: imageSize)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right+10,
                                      y: 5,
                                      width: albumLabelSize.width,
                                      height: min(50, albumLabelSize.height))
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right+10,
                                       y: albumNameLabel.bottom+5,
                                       width: contentView.width-albumCoverImageView.right-5,
                                      height: min(50, albumLabelSize.height))
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right+10,
                                           y: albumCoverImageView.bottom-32,
                                           width: contentView.width-albumCoverImageView.width-20,
                                           height: 32)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
