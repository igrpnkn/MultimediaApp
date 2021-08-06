//
//  SearchResultsViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    private struct SearchSection {
        let title: String
        let results: [SearchResult]
    }
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Tracks", results: tracks)
        ]
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = results.isEmpty
        }
    }

}

extension SearchResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .spotifyGreen
        cell.imageView?.contentMode = .scaleAspectFill
        switch result {
        case .artist(model: let model):
            cell.imageView?.image = UIImage(systemName: "music.mic")
            cell.textLabel?.text = model.name
        case .album(model: let model):
            cell.imageView?.sd_setImage(with: URL(string: model.images.first?.url ?? ""),
                                        placeholderImage: UIImage(systemName: "opticaldisc"),
                                        options: .lowPriority, completed: nil)
            cell.textLabel?.text = model.name
        case .playlist(model: let model):
            cell.imageView?.sd_setImage(with: URL(string: model.images.first?.url ?? ""),
                                        placeholderImage: UIImage(systemName: "music.note.list"),
                                        options: .lowPriority, completed: nil)
            cell.textLabel?.text = model.name
        case .track(model: let model):
            cell.imageView?.sd_setImage(with: URL(string: model.album?.images.first?.url ?? ""),
                                        placeholderImage: UIImage(systemName: "music.note"),
                                        options: .lowPriority,
                                        completed: nil)
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
}
