//
//  ActionLabelView.swift
//  MultimediaApp
//
//  Created by developer on 27.08.2021.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView)
}

class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        layer.cornerRadius = 12
        isHidden = true
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 5, y: height-65, width: width-10, height: 60)
        label.frame = CGRect(x: 5, y: 0, width: width-10, height: height-65)
    }
    
    public func configure(with viewModel: ActionLabelViewViewModel) {
        self.label.text = viewModel.text
        self.button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    @objc
    private func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
}
