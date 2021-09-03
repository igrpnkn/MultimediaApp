//
//  SettingsViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(object: Self.self, method: #function)
        title = "Settings"
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        configureModels()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.log(object: Self.self, method: #function)
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        Logger.log(object: Self.self, method: #function)
        sections.append(Section(title: "Profile",
                                options: [Option(image: UIImage(systemName: "person.crop.circle.fill"),
                                                 title: "View your profile",
                                                 tintColor: .spotifyGreen,
                                                 handler: { [weak self] in
                                                    DispatchQueue.main.async {
                                                        self?.viewProfileDidTap()
                                                    }
                                                 })]))
        sections.append(Section(title: "Account",
                                options: [Option(image: UIImage(systemName: "xmark.circle.fill"),
                                                 title: "Sign Out",
                                                 tintColor: .systemRed,
                                                 handler: { [weak self] in
                                                    DispatchQueue.main.async {
                                                        self?.signOutDidTap()
                                                    }
                                                 })]))
    }
    
    private func viewProfileDidTap() {
        Logger.log(object: Self.self, method: #function)
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutDidTap() {
        Logger.log(object: Self.self, method: #function)
        let alert = UIAlertController(title: "Are you sure?", message: "Next time you should login your account again", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            self?.signUserOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func signUserOut() {
        AuthManager.shared.signOut { [weak self] signedOut in
            if signedOut {
                DispatchQueue.main.async {
                    let navVC = UINavigationController(rootViewController: WelcomeViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if #available(iOS 14.0, *) {
            var content = UIListContentConfiguration.cell()
            content.text = model.title
            content.image = model.image
            cell.contentConfiguration = content
            cell.tintColor = model.tintColor
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].options[indexPath.row].handler()
    }
}

