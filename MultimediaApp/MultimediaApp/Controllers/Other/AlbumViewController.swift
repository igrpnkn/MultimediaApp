//
//  AlbumViewController.swift
//  MultimediaApp
//
//  Created by developer on 03.08.2021.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    private var tracks: [AudioTrack] = []
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    
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
    
    init(with album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = ""//playlist.name
        view.backgroundColor = .systemBackground
        configureCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapShare))
        fetchData ()
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
        guard let url = URL(string: album.external_urls.spotify ?? "") else {
            Logger.log(object: Self.self, method: #function, message: "Was GUARDED with:", body: album.external_urls.spotify, clarification: nil)
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

extension AlbumViewController {
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.global(qos: .default).async {
            self.tracks = []
            APICaller.shared.getAlbumDetails(for: self.album) { [weak self] (result) in
                switch result {
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        self?.tracks.append($0)
                        return RecommendedTrackCellViewModel(name: $0.name,
                                                      artistName: $0.artists.first?.name ?? "Unknown",
                                                      artworkURL: URL(string: model.images.first?.url ?? ""),
                                                      duration: $0.duration_ms)
                    })
                    self?.updateUI()
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

extension AlbumViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as! RecommendedTrackCollectionViewCell
        cell.configureViewModel(with: viewModels[indexPath.row])
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
        header.configure(with: PlaylistHeaderCollectionReusableViewViewModel(
                            playlistName: album.name,
                            description: album.artists.first?.name ?? "Unknown",
                            ownerName: "\(album.album_type) released \(String.formattedDate(string: album.release_date))",
                            artworkURL: URL(string: album.images.first?.url ?? "")))
        header.delegate = self
        return header
    }
        
}

// MARK: - CollectionView Delegate

extension AlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        PlaybackPresenter.shared.startPlayback(form: self, track: self.tracks[indexPath.row])
    }
    
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        Logger.log(object: Self.self, method: #function, message: "Start playling playlist: \(album.name)")
        PlaybackPresenter.shared.startPlayback(form: self, tracks: self.tracks)
    }
    
}

