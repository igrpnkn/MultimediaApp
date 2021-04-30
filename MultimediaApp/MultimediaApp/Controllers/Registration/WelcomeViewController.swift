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
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 25,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-50, height: 60)
        signInButton.layer.cornerRadius = signInButton.height/2
    }
    
    @objc func didTapSignIn() {
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
        // Log user in or yell at them for error
    }
    
}
