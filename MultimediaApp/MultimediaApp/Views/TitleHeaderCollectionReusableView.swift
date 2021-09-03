//
//  TitleHeaderCollectionReusableView.swift
//  MultimediaApp
//
//  Created by developer on 05.08.2021.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
        
    public static let identifier = "TitleHeaderCollectionReusableView"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .semibold )
        label.textAlignment = .natural
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 20,
                                 y: 0,
                                 width: width-40,
                                 height: height)
    }
    
    public func configure(with title: String) {
        self.nameLabel.text = title
    }
}
