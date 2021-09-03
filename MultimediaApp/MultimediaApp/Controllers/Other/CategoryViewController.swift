//
//  CategoryViewController.swift
//  MultimediaApp
//
//  Created by developer on 06.08.2021.
//

import UIKit

class CategoryViewController: UIViewController {

    private let category: CategoryItem
    
    private var playlists: [Playlist] = []
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                     heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                             leading: 5,
                                                             bottom: 5,
                                                             trailing: 5)
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                               subitem: item,
                                                               count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                              leading: 0,
                                                              bottom: 10,
                                                              trailing: 0)
                return NSCollectionLayoutSection(group: group)
            }))
        return collectionView
    }()
    
    init(category: CategoryItem) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        configureCollectionView()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    
    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - Fetching Data from API

extension CategoryViewController {
    
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getCategoryPlaylists(for: category) { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    self?.playlists = model
                    self?.updateUI()
                    break
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function, message: "Failed to fetch data :(", body: error.localizedDescription, clarification: nil)
                    break
                }
            }
        }
    }
    
}

extension CategoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                                                            for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = FeaturedPlaylistCellViewModel(name: playlists[indexPath.row].name,
                                                      artworkURL: URL(string: playlists[indexPath.row].images.first?.url ?? ""),
                                                      creatorName: playlists[indexPath.row].owner.display_name)
        cell.configureViewModel(with: viewModel)
        return cell
    }
    
    
}

extension CategoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(with: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
