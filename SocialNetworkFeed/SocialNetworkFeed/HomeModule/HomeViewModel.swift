//
//  HomeViewModel.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import Foundation

final class HomeViewModel {
    
    func getArticles(page: Int) {
        guard let url = Endpoint.publishedArticles(page: page).url else { return }
        _ = NetworkManager.shared.retrieveArticles(from: url)
    }
    
}
