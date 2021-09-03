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
    
    func playerControlsView(_ playerControlView: PlayerControlsView, didSlideWith volume: Float)
    
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private var isPlaying: Bool = true
    
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
        volumeSlider.addTarget(self, action: #selector(didSlideVolume), for: .valueChanged)
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
        
        let speakerLeft = UIImageView(frame: CGRect(x: volumeSlider.left,
                                                    y: volumeSlider.top-16,
                                                    width: 16, height: 16))
        speakerLeft.image = UIImage(systemName: "speaker")
        speakerLeft.tintColor = .secondaryLabel
        
        let speakerRight = UIImageView(frame: CGRect(x: volumeSlider.right-16,
                                                    y: volumeSlider.top-16,
                                                    width: 16, height: 16))
        speakerRight.image = UIImage(systemName: "speaker.wave.3")
        speakerRight.tintColor = .secondaryLabel
        addSubview(speakerLeft)
        addSubview(speakerRight)
        
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
    
    func configure(with viewModel: PlayerControlsViewViewModel) {
        self.nameLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
    
    @objc
    private func didTapBack() {
        delegate?.playerControlsViewDidTapBack(self)
    }
    
    @objc
    private func didTapPlayPause() {
        isPlaying ?
            playPauseButton.setImage(UIImage(systemName: "play.fill",
                                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                            weight: .medium)),
                                     for: .normal)
            : playPauseButton.setImage(UIImage(systemName: "pause.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                              weight: .medium)),
                                       for: .normal)
        isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPause(self)
    }
    
    @objc
    private func didTapNext() {
        delegate?.playerControlsViewDidTapNext(self)
    }
    
    @objc
    private func didSlideVolume() {
        delegate?.playerControlsView(self, didSlideWith: volumeSlider.value)
    }
    
}
