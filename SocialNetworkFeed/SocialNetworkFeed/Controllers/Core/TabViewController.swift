//
//  TabViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        view.backgroundColor = .secondarySystemBackground
        
        let storageManager = StorageManager()
        let viewModel = HomeViewModel(storageManager: storageManager)
        let homeVC = UINavigationController(rootViewController: HomeViewController(viewModel: viewModel))
        
        let bookmarkedVC = UINavigationController(rootViewController: BookmarkedViewController())
        
        
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "list.dash.header.rectangle"),
                                       tag: 1)
       
        bookmarkedVC.tabBarItem = UITabBarItem(title: "Bookmarked",
                                       image: UIImage(systemName: "bookmark.fill"),
                                       tag: 2)
    
        setViewControllers([homeVC, bookmarkedVC], animated: false)
    }
}
