//
//  ProfileViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        indicator.color = .spotifyGreen
        indicator.hidesWhenStopped = true
        indicator.isHidden = false
        return indicator
    }()
    
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
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func fetchProfile() {
        Logger.log(object: Self.self, method: #function)
        activityIndicator.startAnimating()
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    self?.failedToGetProfile(with: error)
                    break
                }
            }
        }
    }

    private func updateUI(with model: UserProfile) {
        Logger.log(object: Self.self, method: #function)
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        models.append("Name: \(model.display_name)")
        models.append("E-Mail: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Spotify Plan: \(model.product)")
        createTableHeader(with: model.images[0])
        tableView.reloadData()
    }
    
    private func failedToGetProfile(with error: Error) {
        Logger.log(object: Self.self, method: #function, message: error.localizedDescription)
        activityIndicator.stopAnimating()
        let label = UILabel(frame: .zero)
        label.text = "Failed to get profile :("
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
    }
    
    private func createTableHeader(with metaData: APIImage?) {
        Logger.log(object: Self.self, method: #function)
        guard metaData != nil,
              let urlString = metaData?.url,
              let url = URL(string: urlString)
        else {
            Logger.log(object: Self.self, method: #function, message: "Creation header was guarded: metadata is nil.")
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        headerView.backgroundColor = .secondarySystemBackground
        
        let imageSize = headerView.height*0.8
        
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(shadowView)
        shadowView.center = headerView.center
        shadowView.layer.cornerRadius = shadowView.height*0.16
        shadowView.backgroundColor = .systemBackground
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.height*0.16
        imageView.sd_setImage(with: url, completed: nil)
        
        tableView.tableHeaderView = headerView
    }
}
 
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
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
