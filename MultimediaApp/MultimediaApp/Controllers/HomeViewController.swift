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
        fetchData()
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

    private func updateUI<T: Codable>(with: T) {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.main.async {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.width/2, height: self.view.width/2))
            if let _ = with as? NewReleasesRespone {
                imageView.image = UIImage(systemName: "square.grid.3x3.topleft.fill")
            } else if let _ = with as? FeaturedPlaylistsResponse {
                imageView.image = UIImage(systemName: "square.grid.3x3.topmiddle.fill")
            } else if let _ = with as? RecommendedGenresResponse {
                imageView.image = UIImage(systemName: "square.grid.3x3.topright.fill")
            } else {
                return
            }
            imageView.tintColor = .spotifyGreen
            imageView.contentMode = .scaleAspectFill
            self.view.addSubview(imageView)
            imageView.center = self.view.center
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func failedToFetchData(with error: Error) {
        Logger.log(object: Self.self, method: #function, message: error.localizedDescription)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let label = UILabel(frame: .zero)
            label.text = "Failed to fetch some data :("
            label.textColor = .secondaryLabel
            label.sizeToFit()
            self.view.addSubview(label)
            label.center = self.view.center
        }
    }
}

// MARK: - Fetching Data from API

extension HomeViewController {
    
    private func fetchData() {
        activityIndicator.startAnimating()
        fetchNewReleases()
        fetchAllFeaturedPlaylists()
        fetchRecommendedGenres()
    }
    
    private func fetchNewReleases() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getNewReleases { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToFetchData(with: error)
                    break
                }
            }
        }
    }
    
    private func fetchAllFeaturedPlaylists() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getAllFeaturedPlaylists { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToFetchData(with: error)
                    break
                }
            }
        }
    }
    
    private func fetchRecommendedGenres() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getRecommendedGenres { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToFetchData(with: error)
                    break
                }
            }
        }
    }
    
}
