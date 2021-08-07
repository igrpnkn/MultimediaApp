//
//  PlaybackPresenter.swift
//  MultimediaApp
//
//  Created by Игорь Пенкин on 07.08.2021.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    
    static func startPlayback(form viewController: UIViewController, track: AudioTrack) {
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    static func startPlayback(form viewController: UIViewController, tracks: [AudioTrack]) {
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
