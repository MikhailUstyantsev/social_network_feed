//
//  BookmarkedViewController.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import UIKit

class BookmarkedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        title = "Bookmarked"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
