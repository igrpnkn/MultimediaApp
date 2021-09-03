//
//  CategoryCollectionViewCell.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.mic")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.text = "Category"
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
        let labelHeight: CGFloat = 40
        let imageEdge: CGFloat = contentView.height-labelHeight
        coverImageView.frame = CGRect(x: contentView.width-imageEdge-10,
                                      y: 0,
                                      width: imageEdge,
                                      height: imageEdge)
        nameLabel.frame = CGRect(x: 10,
                                 y: contentView.bottom-labelHeight,
                                 width: contentView.width-20,
                                 height: labelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        coverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: CategoryCollectionViewCellViewModel) {
        nameLabel.text = viewModel.title
        
        coverImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "music.mic"), options: .lowPriority, context: nil)
    }
    
    
}
