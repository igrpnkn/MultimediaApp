//
//  LibraryPlaylistsViewController.swift
//  MultimediaApp
//
//  Created by developer on 24.08.2021.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    private var playlists: [Playlist] = []
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitledTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitledTableViewCell.identifier)
        tableView.isHidden = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNoPlaylistsView()
        fetchData()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateUI() {
        Logger.log(object: Self.self, method: #function)
        DispatchQueue.main.async {
            if self.playlists.isEmpty {
                self.tableView.isHidden = true
                self.noPlaylistsView.isHidden = false
            } else {
                self.noPlaylistsView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupNoPlaylistsView() {
        self.view.addSubview(noPlaylistsView)
        self.noPlaylistsView.configure(with:
                                        ActionLabelViewViewModel(text: "You don't have any playlists yet.",
                                                                 actionTitle: "Create"))
        self.noPlaylistsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
    
    public func showCreatePlaylistAlert() {
        Logger.log(object: Self.self, method: #function)
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter playlist name.",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) { isSuccess in
                isSuccess ? self?.fetchData() : Logger.log(object: Self.self,
                                                           method: #function,
                                                           message: "Failed to create Playlist :(")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        Logger.log(object: Self.self, method: #function)
        self.showCreatePlaylistAlert()
    }
    
}

extension LibraryPlaylistsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = PlaylistViewController(with: playlists[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LibraryPlaylistsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitledTableViewCell.identifier, for: indexPath) as? SearchResultSubtitledTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with:
            SearchResultSubtitledTableViewCellViewModel(
                title: playlists[indexPath.row].name,
                subtitle: playlists[indexPath.row].description,
                arkworkURL: URL(string: playlists[indexPath.row].images.first?.url ?? "")))
        return cell
    }
}

// MARK: - Fetching Data

extension LibraryPlaylistsViewController {
    
    private func fetchData() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.global(qos: .default).async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}