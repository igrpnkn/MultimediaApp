//
//  SearchResultSubtitledTableViewCell.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 06.08.2021.
//

import UIKit
import SDWebImage

class SearchResultSubtitledTableViewCell: UITableViewCell {

    static let identifier = "SearchResultSubtitledTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: 10, y: 1, width: contentView.height-2, height: contentView.height-2)
        label.frame = CGRect(x: iconImageView.right+10,
                             y: 0,
                             width: contentView.width-iconImageView.width-30,
                             height: contentView.height/2)
        subtitleLabel .frame = CGRect(x: iconImageView.right+10,
                                      y: label.bottom,
                                      width: contentView.width-iconImageView.width-30,
                                      height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.label.text = nil
        self.subtitleLabel.text = nil
    }
    
    func configure(with model: SearchResultSubtitledTableViewCellViewModel) {
        self.label.text = model.title
        self.subtitleLabel.text = model.subtitle
        self.iconImageView.sd_setImage(with: model.arkworkURL,
                                       placeholderImage: UIImage(systemName: "music.mic"),
                                       options: .lowPriority,
                                       completed: nil)
    }
    
}
