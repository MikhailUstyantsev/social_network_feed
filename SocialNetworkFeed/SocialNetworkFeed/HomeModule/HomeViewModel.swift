//
//  HomeViewModel.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import Foundation
import Combine
import Alamofire

final class HomeViewModel {
    
    let articlesPublisher = PassthroughSubject<[Article], AFError>()
    
    func getArticles(page: Int) {
        guard let url = Endpoint.publishedArticles(page: page).url else { return }
        NetworkManager.shared.retrieveArticles(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let articles):
                self.articlesPublisher.send(articles)
            case .failure(let error):
                self.articlesPublisher.send(completion: .failure(error))
            }
        }
    }
    
    func clearArticles() {
        articlesPublisher.send([])
    }
    
}
