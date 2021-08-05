//
//  PlaylistViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class PlaylistViewController: UIViewController {
 
    private let playlist: Playlist
    
    private var recommendedTracksViewModels = [RecommendedTrackCellViewModel]()
    
    private let collectionView: UICollectionView = {
        return UICollectionView(frame: .zero,
                                collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (index, _) -> NSCollectionLayoutSection? in
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
                                    section.boundarySupplementaryItems = [
                                        NSCollectionLayoutBoundarySupplementaryItem(
                                            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                               heightDimension: .fractionalWidth(1.0)),
                                            elementKind: UICollectionView.elementKindSectionHeader,
                                            alignment: .top)
                                    ]
                                    return section
        }))
    }()
    
    init(with playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""//playlist.name
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchData ()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapShare))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc
    private func didTapShare() {
        guard let url = URL(string: playlist.external_urls.spotify ?? "") else {
            Logger.log(object: Self.self, method: #function, message: "Was GUARDED with:", body: playlist.external_urls, clarification: nil)
            return
        }
        Logger.log(object: Self.self, method: #function, message: "To share for:", body: url, clarification: nil)
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Fetching Data from API

extension PlaylistViewController {
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.global(qos: .default).async {
            APICaller.shared.getPlaylistDetails(for: self.playlist) { [weak self] (result) in
                switch result {
                case .success(let model):
                    if let tracks = model.tracks.items {
                        self?.recommendedTracksViewModels = tracks.compactMap({
                            RecommendedTrackCellViewModel(name: $0.track.name,
                                                          artistName: $0.track.artists.first?.name ?? "Unknown",
                                                          artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""),
                                                          duration: $0.track.duration_ms)
                        })
                        self?.updateUI()
                    } else {
                        Logger.log(object: Self.self, method: #function, message: "Playlist tracks were nil :(")
                    }
                    break
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function, message: "Playlist tracks were nil :(", body: error, clarification: nil)
                    break
                }
            }
        }
    }
}

// MARK: - CollectionView DataSource

extension PlaylistViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedTracksViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as! RecommendedTrackCollectionViewCell
        cell.configureViewModel(with: recommendedTracksViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                                                                            for: indexPath) as? PlaylistHeaderCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        header.configure(with: PlaylistHeaderCollectionReusableViewViewModel(playlistName: playlist.name,
                                                                             description: playlist.description,
                                                                             ownerName: playlist.owner.display_name,
                                                                             artworkURL: URL(string: playlist.images.first?.url ?? "")))
        header.delegate = self
        return header
    }
        
}

// MARK: - CollectionView Delegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let cell = collectionView.cellForItem(at: indexPath) as? RecommendedTrackCollectionViewCell {
            cell.contentView.backgroundColor = UIColor.mainColors.randomElement()
        }
    }
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        Logger.log(object: Self.self, method: #function, message: "Start playling playlist: \(playlist.name)")
        // TODO: start playing playlist in queue
    }
    
}
