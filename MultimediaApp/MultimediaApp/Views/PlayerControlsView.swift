//
//  PlayerControlsView.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 07.08.2021.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    
    func playerControlsViewDidTapBack(_ playerControlsView: PlayerControlsView)
    
    func playerControlsViewDidTapNext(_ playerControlsView: PlayerControlsView)
    
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .spotifyGreen
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Playable Track Name"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.text = "Playable Track Subtitle"
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                                        weight: .medium))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                                        weight: .medium))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                                        weight: .medium))
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(playPauseButton)
        addSubview(nextButton)
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buffer: CGFloat = 10
        nameLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width,
                                 height: 32)
        subtitleLabel.frame = CGRect(x: 0,
                                     y: nameLabel.bottom+buffer,
                                     width: width,
                                     height: 26)
        volumeSlider.frame = CGRect(x: buffer,
                                    y: subtitleLabel.bottom+buffer*2,
                                    width: width-buffer*2,
                                    height: 36)
        let buttonSize: CGFloat = 48
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2,
                                       y: volumeSlider.bottom+buffer*2,
                                       width: buttonSize,
                                       height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left-buttonSize-buffer*4,
                                  y: playPauseButton.top,
                                  width: buttonSize,
                                  height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right+buffer*4,
                                  y: playPauseButton.top,
                                  width: buttonSize,
                                  height: buttonSize)
    }
    
    @objc
    private func didTapBack() {
        delegate?.playerControlsViewDidTapBack(self)
    }
    
    @objc
    private func didTapPlayPause() {
        delegate?.playerControlsViewDidTapPlayPause(self)
    }
    
    @objc
    private func didTapNext() {
        delegate?.playerControlsViewDidTapNext(self)
    }
    
}
