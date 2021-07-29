//
//  ProfileViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile() {
        Logger.log(object: Self.self, method: #function)
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToGetProfile()
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func updateUI(with model: UserProfile) {
        Logger.log(object: Self.self, method: #function)
        tableView.isHidden = false
        models.append("Full Name: \(model.display_name)")
        models.append("E-Mail: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Spotify Plan: \(model.product)")
        tableView.reloadData()
    }
    
    private func failedToGetProfile() {
        Logger.log(object: Self.self, method: #function)
        let label = UILabel(frame: .zero)
        label.text = "Failed to get profile :("
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
}
 
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Information"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if #available(iOS 14.0, *) {
            var content = UIListContentConfiguration.cell()
            content.text = models[indexPath.row]
            content.image = UIImage(systemName: "info.circle.fill")
            cell.tintColor = .spotifyGreen
            cell.contentConfiguration = content
        }
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
