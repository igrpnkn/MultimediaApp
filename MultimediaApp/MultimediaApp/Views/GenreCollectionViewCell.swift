//
//  GenreCollectionViewCell.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.mic")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        label.text = "Genre"
        label.numberOfLines = 2
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.mainColors.randomElement()?.withAlphaComponent(0.8)
        contentView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 12
        coverImageView.frame = CGRect(x: contentView.width/2,
                                      y: 5,
                                      width: contentView.width/2,
                                      height: contentView.height-10)
        nameLabel.frame = CGRect(x: 10,
                                 y: contentView.height/2,
                                 width: contentView.width-20,
                                 height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        coverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: NewReleasesCellViewModel) {
        nameLabel.text = viewModel.name
        coverImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "music.mic"), options: .lowPriority, context: nil) //(with: viewModel.artworkURL, completed: nil)
    }
    
    
}
