//
//  LibraryAlbumsViewController.swift
//  MultimediaApp
//
//  Created by developer on 24.08.2021.
//

import UIKit


class LibraryAlbumsViewController: UIViewController {
    
    private var albums: [Album] = []
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitledTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitledTableViewCell.identifier)
        tableView.isHidden = true
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlDidSwipe), for: .valueChanged)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        view.backgroundColor = .systemBackground
        addObservers()
        setupTableView()
        setupNoAlbumsView()
        fetchData()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshControlDidSwipe),
                                               name: .albumSavedNotification,
                                               object: nil)
    }
    
    private func setupTableView() {
        Logger.log(object: Self.self, method: #function)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateUI() {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.main.async {
            if self.albums.isEmpty {
                self.tableView.isHidden = true
                self.noAlbumsView.isHidden = false
            } else {
                self.noAlbumsView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupNoAlbumsView() {
        self.view.addSubview(noAlbumsView)
        self.noAlbumsView.configure(with:
                                        ActionLabelViewViewModel(text: "You don't have any saved Albums yet.",
                                                                 actionTitle: "Browse"))
        self.noAlbumsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        noAlbumsView.center = CGPoint(x: view.width/2, y: view.height/2)
        tableView.frame = self.view.bounds
    }
  
    @objc
    private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        Logger.log(object: Self.self, method: #function)
        //self.showCreatePlaylistAlert()
        tabBarController?.selectedIndex = 0
    }
    
}

extension LibraryAlbumsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AlbumViewController(with: albums[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LibraryAlbumsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitledTableViewCell.identifier, for: indexPath) as? SearchResultSubtitledTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with:
            SearchResultSubtitledTableViewCellViewModel(
                title: albums[indexPath.row].name,
                subtitle: albums[indexPath.row].album_type,
                arkworkURL: URL(string: albums[indexPath.row].images.first?.url ?? "")))
        return cell
    }
}


// MARK: - Fetching Data

extension LibraryAlbumsViewController {
    
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    self?.updateUI()
                    print(error)
                }
            }
        }
    }
    
    @objc
    private func refreshControlDidSwipe() {
        Logger.log(object: Self.self, method: #function)
        self.fetchData()
        tableView.refreshControl?.endRefreshing()
    }
    
}

