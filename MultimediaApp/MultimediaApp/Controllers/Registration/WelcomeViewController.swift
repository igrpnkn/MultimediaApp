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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albumCovers")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        return view
    }()
    
    private let promoView: UIView = {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: 280,
                                        height: 280))
        view.layer.opacity = 0
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.width,
                                                  height: view.height/2))
        imageView.image = UIImage(named: "originalSpotify")
        imageView.contentMode = .scaleAspectFit
        let label = UILabel(frame: CGRect(x: 10,
                                          y: imageView.bottom+10,
                                          width: view.width-20,
                                          height: view.height-imageView.height-20))
        label.text = "Built with Spotify API.\nOverview project on\ngithub.com/Igor-A-Penkin"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 3
        label.textAlignment = .center
        view.addSubview(imageView)
        view.addSubview(label)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Muse.me"
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(promoView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        promoView.center = CGPoint(x: view.width+promoView.width/2,
                                   y: view.center.y)
        signInButton.frame = CGRect(x: 30,
                                    y: view.height-90-view.safeAreaInsets.bottom,
                                    width: view.width-60, height: 60)
        signInButton.layer.cornerRadius = signInButton.height/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.promoView.layer.opacity = 1
            self.promoView.center = self.view.center
        } completion: {_ in }
    }
    
    @objc func didTapSignIn() {
        Logger.log(object: Self.self, method: #function)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            self.promoView.layer.opacity = 0
            self.promoView.center = CGPoint(x: -self.view.width,
                                            y: self.view.center.y)
        } completion: {_ in
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
            self.navigationController?.pushViewController(authViewController, animated: true)
        }
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
