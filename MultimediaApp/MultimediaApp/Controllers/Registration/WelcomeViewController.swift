//
//  WelcomeViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.spotifyGreen
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Spotify"
        view.backgroundColor = .systemBackground
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 30,
                                    y: view.height-90-view.safeAreaInsets.bottom,
                                    width: view.width-60, height: 60)
        signInButton.layer.cornerRadius = signInButton.height/2
    }
    
    @objc func didTapSignIn() {
        Logger.log(object: Self.self, method: #function)
        let authViewController = AuthViewController()
        authViewController.navigationItem.largeTitleDisplayMode = .never
        authViewController.completionHandler = { [weak self] success in
            guard self != nil else {
                print("INFO: Error - WelcomeViewController was unexpectedly nil.")
                return
            }
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        navigationController?.pushViewController(authViewController, animated: true)
    }

    private func handleSignIn(success: Bool) {
        Logger.log(object: Self.self, method: #function)
        // Log user in or yell at them for error
        guard success else {
            Logger.log(object: Self.self, method: #function, message: "Was guarded.")
            let alert = UIAlertController(title: "Ooops!",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert, animated: true)
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        self.present(mainAppTabBarVC, animated: true, completion: nil)
    }
    
}
