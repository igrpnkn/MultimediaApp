//
//  HomeViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private enum BrowseSectionType {
        case newReleases(viewModels: [NewReleasesCellViewModel])
        case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
        case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
        
        var titleHeader: String {
            switch self {
            case .newReleases:
                return "New albums"
            case .featuredPlaylists:
                return "Featured playlists"
            case .recommendedTracks:
                return "Recommended tracks"
            }
        }
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
    
    private var sections = [BrowseSectionType]()
    
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
        configureCollectionView()
        view.addSubview(activityIndicator)
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
            } else if let _ = with as? AudioTrack {
                imageView.image = UIImage(systemName: "square.grid.3x3.middle.fill")
            } else if let _ = with as? AudioTracks {
                imageView.image = UIImage(systemName: "square.grid.3x3.middleright.fill")
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
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
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
        let supplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        let offset: CGFloat = 10
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
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
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    private static func createFeaturedPlaylistsLayout() -> NSCollectionLayoutSection {
        let supplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        let baseEdge: CGFloat = 160
        let offset: CGFloat = 10
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(baseEdge),
                                                                             heightDimension: .absolute(baseEdge)))
        item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
        
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
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    private static func createRecommendedTracksLayout() -> NSCollectionLayoutSection {
        let supplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        let offset: CGFloat = 10
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: offset, leading: offset, bottom: offset, trailing: offset)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitem: item,
                                                     count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
}

// MARK: - CollectionView DataSource

extension HomeViewController: UICollectionViewDataSource {
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "Unknown",
                                            albumType: $0.album_type)
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name:  $0.name,
                                                 artworkURL: URL(string: $0.images.first?.url ?? ""),
                                                 creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name,
                                                 artistName: $0.artists.first?.name ?? "Unknown",
                                                 artworkURL: URL(string: $0.album?.images.first?.url ?? ""),
                                                 duration: $0.duration_ms)
        })))
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configureViewModel(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as? TitleHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let model = sections[indexPath.section]
        header.configure(with: model.titleHeader)
        return header
    }
    
}

// MARK: - CollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .newReleases:
            let vc = AlbumViewController(with: newAlbums[indexPath.row])
            vc.navigationItem.largeTitleDisplayMode = .always
            navigationController?.pushViewController(vc, animated: true)
            break
        case .featuredPlaylists:
            let vc = PlaylistViewController(with: playlists[indexPath.row])
            vc.navigationItem.largeTitleDisplayMode = .always
            navigationController?.pushViewController(vc, animated: true)
            break
        case .recommendedTracks:
            PlaybackPresenter.startPlayback(form: self, track: tracks[indexPath.row])
            break
        }
    }
    
}

// MARK: - Fetching Data from API

extension HomeViewController {
    
    private func fetchData() {
        activityIndicator.startAnimating()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        var newReleases: NewReleasesRespone?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        APICaller.shared.getNewReleases { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let model):
                newReleases = model
                break
            case .failure(let error):
                Logger.log(object: Self.self, method: #function, message: "ERROR", body: error.localizedDescription, clarification: nil)
                break
            }
        }
        
        APICaller.shared.getAllFeaturedPlaylists { result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylists = model
                break
            case .failure(let error):
                Logger.log(object: Self.self, method: #function, message: "ERROR", body: error.localizedDescription, clarification: nil)
                break
            }
        }
        
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count <= 4 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer {
                        dispatchGroup.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendations = model
                        break
                    case .failure(let error):
                        Logger.log(object: Self.self, method: #function, message: "ERROR", body: error.localizedDescription, clarification: nil)
                        break
                    }
                }
                break
            case .failure(let error):
                Logger.log(object: Self.self, method: #function, message: "ERROR", body: error.localizedDescription, clarification: nil)
                break
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {
                fatalError("Models are nil.")
            }
            Logger.log(object: Self.self, method: #function, message: "Configuring View Models.")
            self.configureModels(newAlbums: newAlbums,
                                 playlists: playlists,
                                 tracks: tracks)
            self.activityIndicator.stopAnimating()
        }
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
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getRecommendations(genres: genres) { [weak self] result in
            switch result {
            case .success(let model):
                self?.updateUI(with: model)
                self?.fetchTrack(with: model.tracks.first?.id ?? "")
                self?.fetchSeveralTracks(with: model.tracks)
                break
            case .failure(let error):
                self?.failedToFetchData(with: error)
                break
            }
        }
    }
    
    private func fetchTrack(with id: String) {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getTrack(with: id) { [weak self] result in
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
    
    private func fetchSeveralTracks(with model: [AudioTrack]) {
        Logger.log(object: Self.self, method: #function)
        let tracks = model
        var ids = Set<String>()
        while ids.count <= 15 {
            if let random = tracks.randomElement()?.id {
                ids.insert(random)
            }
        }
        APICaller.shared.getSeveralTracks(with: ids) { [weak self] result in
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
    
