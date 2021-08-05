//
//  FeaturedPlaylistCollectionViewCell.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 01.08.2021.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground//UIColor.mainColors.randomElement()?.withAlphaComponent(0.5)
        contentView.clipsToBounds = true
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        let offset: CGFloat = 5
        creatorNameLabel.frame = CGRect(x: offset,
                                        y: contentView.height-16,
                                        width: contentView.width-offset*2,
                                        height: 14)
        playlistNameLabel.frame = CGRect(x: offset,
                                         y: creatorNameLabel.top-34,
                                         width: contentView.width-offset*2,
                                         height: 34)
        let imageSize = contentView.height-playlistNameLabel.height-creatorNameLabel.height-offset*2
        playlistCoverImageView.frame = CGRect(x: (contentView.width-imageSize)/2,
                                              y: offset,
                                              width: imageSize,
                                              height: imageSize)
        playlistCoverImageView.layer.cornerRadius = imageSize/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "opticaldisc"), options: .lowPriority, context: nil)
    }
    
}
