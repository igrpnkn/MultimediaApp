//
//  TabBarViewController.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tab Bar Controller"
        tabBar.tintColor = .spotifyGreen
        tabBar.isOpaque = false
        tabBar.isTranslucent = true
        setBarTree()
    }
    
    private func setBarTree() {
        let vc0 = HomeViewController()
        let vc1 = SearchViewController()
        let vc2 = LibraryViewController()
        
        vc0.navigationItem.largeTitleDisplayMode = .always
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        
        let nav0 = UINavigationController(rootViewController: vc0)
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        
        nav0.navigationBar.prefersLargeTitles = true
        nav1.navigationBar.prefersLargeTitles = true
        nav2 .navigationBar.prefersLargeTitles = true
        
        nav0.navigationBar.tintColor = .spotifyGreen
        nav1.navigationBar.tintColor = .spotifyGreen
        nav2.navigationBar.tintColor = .spotifyGreen
        
        let imageConf = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        nav0.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "house.circle", withConfiguration: imageConf), tag: 1)
        nav0.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill", withConfiguration: imageConf)
        nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle", withConfiguration: imageConf), tag: 1)
        nav1.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: imageConf)
        nav2.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "book.circle", withConfiguration: imageConf), tag: 1)
        nav2.tabBarItem.selectedImage = UIImage(systemName: "book.circle.fill", withConfiguration: imageConf)
        
        self.setViewControllers([nav0, nav1, nav2], animated: false)
    }
    
     

}
