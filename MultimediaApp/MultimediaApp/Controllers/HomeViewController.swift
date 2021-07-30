//
//  HomeViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class HomeViewController: UIViewController {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        indicator.color = .spotifyGreen
        indicator.hidesWhenStopped = true
        indicator.isHidden = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = .spotifyGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        view.addSubview(activityIndicator)
        fetchNewReleases()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    @objc
    private func didTapSettings() {
        Logger.log(object: Self.self, method: #function)
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }

    private func fetchNewReleases() {
        Logger.log(object: Self.self, method: #function)
        activityIndicator.startAnimating()
        APICaller.shared.getNewReleases { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToGetProfile(with: error)
                    break
                }
            }
        }
    }
    
    private func updateUI(with: NewReleasesRespone) {
        Logger.log(object: Self.self, method: #function)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2))
        imageView.image = UIImage(systemName: "music.note.house")
        imageView.tintColor = .spotifyGreen
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.center = view.center
        activityIndicator.stopAnimating()
    }
    
    private func failedToGetProfile(with error: Error) {
        Logger.log(object: Self.self, method: #function, message: error.localizedDescription)
        activityIndicator.stopAnimating()
        let label = UILabel(frame: .zero)
        label.text = "Failed to get new releases :("
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
}
