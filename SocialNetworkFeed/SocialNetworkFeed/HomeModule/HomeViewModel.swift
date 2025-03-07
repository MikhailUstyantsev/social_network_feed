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
    
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager ) {
        self.storageManager = storageManager
    }
    
    let articlesPublisher = PassthroughSubject<[Article], AFError>()
    
    private var articles: [Article] = []
    
    func getArticles(page: Int) {
        guard let url = Endpoint.publishedArticles(page: page).url else { return }
        NetworkManager.shared.retrieveArticles(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let fetchedArticles):
                // Update each article's bookmark state
                let updatedArticles = fetchedArticles.map { article -> Article in
                    var mutableArticle = article
                    mutableArticle.isBookmarked = self.storageManager.isBookmarked(articleID: article.id ?? 0)
                    return mutableArticle
                }
                self.articles = updatedArticles
                self.articlesPublisher.send(updatedArticles)
            case .failure(let error):
                self.articlesPublisher.send(completion: .failure(error))
            }
        }
    }
    
    func clearArticles() {
        articles = []
        articlesPublisher.send([])
    }
    
    /// Toggle bookmark status for a given article.
    func toggleBookmark(for article: Article) {
        if storageManager.isBookmarked(articleID: article.id ?? 0) {
            storageManager.removeBookmark(articleID: article.id ?? 0)
        } else {
            storageManager.addBookmark(article: article)
        }
        
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isBookmarked.toggle()
            articlesPublisher.send(articles)
        }
    }
}
