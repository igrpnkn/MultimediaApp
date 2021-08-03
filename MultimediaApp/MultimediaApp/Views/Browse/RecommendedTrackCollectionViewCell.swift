//
//  RecommendedTrackCollectionViewCell.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 01.08.2021.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let albumLabel = UILabel()
        albumLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        albumLabel.numberOfLines = 1
        return albumLabel
    }()

    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        artistNameLabel.numberOfLines = 1
        return artistNameLabel
    }()
    
    private let durationLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        artistNameLabel.numberOfLines = 1
        return artistNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground//UIColor.mainColors.randomElement()?.withAlphaComponent(0.5)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(durationLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let offset: CGFloat = 5
        let imageSize: CGFloat = contentView.height
        albumCoverImageView.frame = CGRect(x: offset,
                                           y: 0,
                                           width: imageSize,
                                           height: imageSize)
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right+offset*2,
                                      y: 0,
                                      width: contentView.width-imageSize-offset*4,
                                      height: imageSize/2)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right+offset*2,
                                       y: trackNameLabel.bottom,
                                       width: trackNameLabel.width,
                                       height: imageSize/2)
        durationLabel.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        durationLabel.text = "000:00"
    }
    
}
