//
//  HomeViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapProfile))
        navigationItem.rightBarButtonItem?.tintColor = .spotifyGreen
    }
    
    @objc
    private func didTapProfile() {
        Logger.log(object: Self.self, method: #function)
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }

}
