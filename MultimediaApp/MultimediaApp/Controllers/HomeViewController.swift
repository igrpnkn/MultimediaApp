//
//  HomeViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    private enum BrowseSectionType: Int {
        case newReleases
        case featuredPlaylists
        case recommendedTracks
    }
    
    private var collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _  -> NSCollectionLayoutSection? in
                                                    return HomeViewController.createSectionLayout(section: sectionIndex)
                                                  }))
    
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
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        collectionView.frame = view.bounds
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
            let imageView = UIImageView(frame: CGRect(x: 16,
                                                      y: (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)+4,
                                                      width: 32,
                                                      height: 32))
            if let _ = with as? NewReleasesRespone {
                imageView.image = UIImage(systemName: "square.grid.3x3.topleft.fill")
            } else if let _ = with as? FeaturedPlaylistsResponse {
                imageView.image = UIImage(systemName: "square.grid.3x3.topmiddle.fill")
            } else if let _ = with as? RecommendedGenresResponse {
                imageView.image = UIImage(systemName: "square.grid.3x3.topright.fill")
            } else if let _ = with as? RecommendationsResponse {
                imageView.image = UIImage(systemName: "square.grid.3x3.middleleft.fill")
            } else {
                return
            }
            imageView.tintColor = .systemGreen
            imageView.contentMode = .scaleAspectFill
            self.view.addSubview(imageView)
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

// MARK: - CollectionView CollectionLayoutSection

extension HomeViewController {
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return createNewReleasesLayout()
        case 1:
            return createFeaturedPlaylistsLayout()
        case 2:
            return createRecommendedTracksLayout()
        default:
            return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))))
        }
    }
    
    private static func createNewReleasesLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(360))
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(360))
        // Vertical group in horizontal group
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                     subitem: item,
                                                     count: 3)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                     subitem: verticalGroup,
                                                     count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private static func createFeaturedPlaylistsLayout() -> NSCollectionLayoutSection {
        let baseEdge: CGFloat = 140
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(baseEdge),
                                                                             heightDimension: .absolute(baseEdge)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(baseEdge),
                                               heightDimension: .absolute(baseEdge*2))
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(baseEdge),
                                               heightDimension: .absolute(baseEdge*2))
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                     subitem: item,
                                                     count: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                     subitem: verticalGroup,
                                                     count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private static func createRecommendedTracksLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitem: item,
                                                     count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}

// MARK: - CollectionView DataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard #available(iOS 14.0, *) else {
            return cell
        }
        if (indexPath.section == 0) {
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: "play.rectangle.fill")
            content.text = "New Release"
            content.secondaryText = "The latest release will be available soon."
            cell.contentConfiguration = content
            cell.tintColor = UIColor.mainColors.randomElement() ?? .spotifyGreen
            cell.backgroundColor = (UIColor.mainColors.randomElement() ?? .spotifyGreen).withAlphaComponent(0.4)
        } else if (indexPath.section == 1) {
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: "music.note.list")
            content.text = "Featured Playlist"
            content.secondaryText = "The FP will be here."
            cell.contentConfiguration = content
            cell.tintColor = UIColor.mainColors.randomElement() ?? .spotifyGreen
            cell.backgroundColor = (UIColor.mainColors.randomElement() ?? .spotifyGreen).withAlphaComponent(0.4)
        } else if (indexPath.section == 2) {
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(systemName: "star.leadinghalf.fill")
            content.text = "Recommended Track"
            content.secondaryText = "The track only for your is coming..."
            cell.contentConfiguration = content
            cell.tintColor = UIColor.mainColors.randomElement() ?? .spotifyGreen
            cell.backgroundColor = (UIColor.mainColors.randomElement() ?? .spotifyGreen).withAlphaComponent(0.4)
        } else {
            cell.backgroundColor = (UIColor.mainColors.randomElement() ?? .spotifyGreen).withAlphaComponent(0.4)
        }
        cell.layer.cornerRadius = 12
        return cell
    }
}

// MARK: - CollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    
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
                    let genres = model.genres
                    var seeds = Set<String>()
                    while seeds.count <= 4 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    self?.fetchRecommendations(genres: seeds)
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToFetchData(with: error)
                    break
                }
            }
        }
    }
    
    private func fetchRecommendations(genres: Set<String>) {
        APICaller.shared.getRecommendations(genres: genres) { [weak self] result in
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

