//
//  SearchViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Albums, Artists"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
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
                                                        heightDimension: .absolute(120))
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
    
    private var categories: [CategoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 15, y: 0, width: view.width-30, height: view.height)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - CollectionView DataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureViewModel(with:
            CategoryCollectionViewCellViewModel(
                title: categories[indexPath.row].name,
                artworkURL: URL(
                    string: categories[indexPath.row].icons.first?.url ?? "")))
        return cell
    }
    
}

// MARK: - CollectionView Delegate

extension SearchViewController: UICollectionViewDelegate {
    /*
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
//            let vc = PlaylistViewController(with: playlists[indexPath.row])
//            vc.navigationItem.largeTitleDisplayMode = .always
//            navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    */
}

// MARK: - Search Results

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        Logger.log(object: Self.self, method: #function, message: "Searching query: \(query )")
        // TODO: searching
//        resultsController.updateSearch(with: query)
        
    }
    
}

// MARK: - Fetching Data from API

extension SearchViewController {
    
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getAllCategories { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.updateUI()
                    break
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function, message: "", body: error.localizedDescription, clarification: nil)
                    break
                }
            }
        }
    }
    
    private func fetchCategory(with item: CategoryItem) {
        APICaller.shared.getCategory(category: item) { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function, message: "", body: error.localizedDescription, clarification: nil)
                    break
                }
            }
        }
    }
    
    private func fetchCategoryPlaylists(for category: CategoryItem) {
        APICaller.shared.getCategoryPlaylists(for: category) { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    Logger.log(object: Self.self, method: #function, message: "", body: error.localizedDescription, clarification: nil)
                    break
                }
            }
        }
    }
    
}

