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
        imageView.image = UIImage(systemName: "opticaldisc")
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
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
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
        let durationWidth: CGFloat = 48
        albumCoverImageView.frame = CGRect(x: offset,
                                           y: 0,
                                           width: imageSize,
                                           height: imageSize)
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right+offset*2,
                                      y: 0,
                                      width: contentView.width-imageSize-durationWidth-offset*4,
                                      height: imageSize/2)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right+offset*2,
                                       y: trackNameLabel.bottom,
                                       width: trackNameLabel.width-durationWidth,
                                       height: imageSize/2)
        durationLabel.frame = CGRect(x: width-durationWidth-offset, y: imageSize/4, width: durationWidth, height: imageSize/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
        durationLabel.text = nil
    }
    
    func configureViewModel(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "opticaldisc"), options: .lowPriority, completed: nil) //sd_setImage(with: viewModel.artworkURL, completed: nil)
        let totalSeconds = (viewModel.duration/1000)
        let minutes = totalSeconds/60
        let seconds = totalSeconds%60
        if (seconds <= 9) {
            durationLabel.text = "\(minutes):0\(seconds)"
        } else {
            durationLabel.text = "\(minutes):\(seconds)"
        }
    }
    
}
