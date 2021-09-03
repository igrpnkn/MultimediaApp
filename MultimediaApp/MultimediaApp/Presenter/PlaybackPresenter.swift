//
//  PlaybackPresenter.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 07.08.2021.
//

import Foundation
import AVFoundation
import UIKit

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    var playerVC: PlayerViewController?
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var index: Int = 0
    
    private var track: AudioTrack?
    private var tracks: [AudioTrack] = []
    
    var currentTrack: AudioTrack? {
        if let track = self.track, self.tracks.isEmpty {
            return track
        } else if let _ = playerQueue, !self.tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    private init() {
    }
    
    func startPlayback(form viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            showHasNoPreview(from: viewController)
            Logger.log(object: Self.self, method: #function, message: "Playback was GUARDED :(")
            return
        }
        player = nil
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .spotifyGreen
        viewController.present(navController, animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(form viewController: UIViewController, tracks: [AudioTrack]) {
        playerQueue = nil
        var avPlayerItems: [AVPlayerItem] = []
        self.track = nil
        self.tracks = tracks.compactMap({
            if let url = URL(string: $0.preview_url ?? "") {
                avPlayerItems.append(AVPlayerItem(url: url))
            }
            return $0
        })
        playerQueue = AVQueuePlayer(items: avPlayerItems)
        playerQueue?.volume = 0.5
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .spotifyGreen
        viewController.present(navController, animated: true) { [weak self] in
            self?.playerQueue?.play()
        }
        self.playerVC = vc
    }
    
    func showHasNoPreview(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Ooops!", message: "Your free Spotify's Open plan does not povide you with free preview audio for this song.", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Try another song", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var trackName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "") 
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func didTapPlayPause() {
        if let player = self.player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = self.playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapNext() {
        if tracks.isEmpty {
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            self.index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBack() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(playerItem: firstItem)
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }
    
    func didSlideVolume(_ value: Float) {
        player?.volume = value
    }
    
}
