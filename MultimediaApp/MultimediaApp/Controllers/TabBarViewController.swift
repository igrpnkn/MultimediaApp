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
        view.backgroundColor = .brown
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
        
        nav0.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "house.circle"), tag: 1)
        nav0.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill")
        nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), tag: 1)
        nav1.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        nav2.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "book.circle"), tag: 1)
        nav2.tabBarItem.selectedImage = UIImage(systemName: "book.circle.fill")
        
        self.setViewControllers([nav0, nav1, nav2], animated: false)
    }
    
     

}
