//
//  PlaylistViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    public var isOwner: Bool = false
    
    private let playlist: Playlist
    
    private var tracks: [AudioTrack] = []
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapShare))
        configureCollectionView()
        addGestureRecognizers()
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
    
    private func addGestureRecognizers() {
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(removeTrackFromPlaylist(_:))))
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
    
    @objc
    private func removeTrackFromPlaylist(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              self.isOwner else {
            Logger.log(object: Self.self, method: #function, message: "⛔️ Long press has been guarded :(")
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            Logger.log(object: Self.self, method: #function, message: "⛔️ IndexPath for Long pressed Item has been guarded :(")
            return
        }
        Logger.log(object: Self.self, method: #function, message: "✅ Long press has been passed")
        let trackToDelete = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: trackToDelete.name,
                                            message: "Would you like to remove this from Playlist?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let weakSelf = self else {
                Logger.log(object: Self.self, method: #function, message: "⛔️ Self is unexpectedly nil")
                return
            }
            weakSelf.deleteData(with: trackToDelete, from: weakSelf.playlist)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
}

// MARK: - Fetching Data from API

extension PlaylistViewController {
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.global(qos: .default).async {
            self.tracks = []
            APICaller.shared.getPlaylistDetails(for: self.playlist) { [weak self] (result) in
                switch result {
                case .success(let model):
                    if let tracks = model.tracks.items {
                        self?.recommendedTracksViewModels = tracks.compactMap({
                            self?.tracks.append($0.track)
                            return RecommendedTrackCellViewModel(name: $0.track.name,
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
    
    private func deleteData(with track: AudioTrack, from playlist: Playlist) {
        APICaller.shared.removeTrackFromPlaylist(track: track,
                                                 playlist: playlist) { result in
            // I did it again 🙈
            // TODO: - ⛔️ Rewrite this shit later more clean
            DispatchQueue.main.async {
                switch result {
                case .success(let succeed):
                    guard succeed else {
                        Logger.log(object: Self.self, method: #function, message: "⚠️ Failed to remove Track")
                        return
                    }
                    let actionLabel = ActionLabelView()
                    actionLabel.delegate = self
                    actionLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
                    actionLabel.center = self.view.center
                    actionLabel.configure(with:
                        ActionLabelViewViewModel(text: "Track has been removed successfully!",
                                                 actionTitle: "OK"))
                    actionLabel.layer.opacity = 0.1
                    self.view.addSubview(actionLabel)
                    actionLabel.isHidden = false
                    UIView.animate(withDuration: 0.5) {
                        actionLabel.layer.opacity = 1
                    }
                    self.fetchData()
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function,
                               message: "Error while adding Track to Playlist",
                               body: error.localizedDescription,
                               clarification: nil)
                    let actionLabel = ActionLabelView()
                    actionLabel.delegate = self
                    actionLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
                    actionLabel.center = self.view.center
                    actionLabel.configure(with:
                        ActionLabelViewViewModel(text: "Failed to delete :(",
                                                 actionTitle: "OK"))
                    actionLabel.layer.opacity = 0.8
                    actionLabel.isHidden = true
                    self.view.addSubview(actionLabel)
                    UIView.animate(withDuration: 1) {
                        actionLabel.isHidden = false
                        actionLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
                        actionLabel.center = self.view.center
                    }
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
        PlaybackPresenter.shared.startPlayback(form: self,
                                        track: self.tracks[indexPath.row])
    }
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        Logger.log(object: Self.self, method: #function, message: "Start playling playlist: \(playlist.name)")
        PlaybackPresenter.shared.startPlayback(form: self, tracks: self.tracks)
    }
    
}

extension PlaylistViewController: ActionLabelViewDelegate {
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
