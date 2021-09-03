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
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.forward"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapShare)),
            UIBarButtonItem(image: UIImage(systemName: "heart"),
                            style: .plain,
                            target: self,
                            action: #selector(didTapFavorite))
        ]
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
    
    @objc
    private func didTapFavorite() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.saveAlbumForCurrentUser(album: album) { success in
            DispatchQueue.main.async {
                let actionLabel = ActionLabelView()
                actionLabel.delegate = self
                actionLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
                actionLabel.center = self.view.center
                actionLabel.layer.opacity = 0.1
                self.view.addSubview(actionLabel)
                actionLabel.isHidden = false
                if success {
                    actionLabel.configure(with:
                        ActionLabelViewViewModel(text: "Album was added to Favorites!",
                                                 actionTitle: "OK"))
                    NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
                    HapticsManager.shared.vibrate(for: .success)
                } else {
                    actionLabel.configure(with:
                        ActionLabelViewViewModel(text: "Something gone wrong :(",
                                                 actionTitle: "OK"))
                    HapticsManager.shared.vibrate(for: .error)
                }
                UIView.animate(withDuration: 0.5) {
                    actionLabel.layer.opacity = 1
                }
            }
        }
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
        var selectedTrack = self.tracks[indexPath.row]
        selectedTrack.album = album
        PlaybackPresenter.shared.startPlayback(form: self, track: selectedTrack)
    }
    
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        Logger.log(object: Self.self, method: #function, message: "Start playling playlist: \(album.name)")
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlayback(form: self, tracks: tracksWithAlbum)
    }
    
}

extension AlbumViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        Logger.log(object: Self.self, method: #function)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut) {
            actionLabelView.transform = CGAffineTransform(a: 0.1, b: 0, c: 0, d: 0.1, tx: 0, ty: 0)
            actionLabelView.layer.opacity = 0.1
        } completion: { _ in
            actionLabelView.removeFromSuperview()
        }
    }
}
