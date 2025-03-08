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
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var hasMoreArticles: Bool = true
    private var articles: [Article] = []
    
    let articlesPublisher = PassthroughSubject<[Article], AFError>()
    let isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    init(storageManager: StorageManager ) {
        self.storageManager = storageManager
    }
    
    func getArticles(page: Int) {
        guard !isLoading, hasMoreArticles, let url = Endpoint.publishedArticles(page: page).url else { return }
        
        isLoading = true
        isLoadingPublisher.send(true)
        NetworkManager.shared.retrieveArticles(from: url) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            self.isLoadingPublisher.send(false)
            switch result {
            case .success(let fetchedArticles):
                // Update each article's bookmark state
                let updatedArticles = fetchedArticles.map { article -> Article in
                    var mutableArticle = article
                    mutableArticle.isBookmarked = self.storageManager.isBookmarked(articleID: article.id ?? 0)
                    return mutableArticle
                }
                
                if page == 1 {
                    self.articles = updatedArticles
                } else {
                    self.articles.append(contentsOf: updatedArticles)
                }
                
                if updatedArticles.isEmpty {
                    self.hasMoreArticles = false
                } else {
                    self.currentPage = page
                }
                
                self.articlesPublisher.send(self.articles)
            case .failure(let error):
                self.articlesPublisher.send(completion: .failure(error))
            }
        }
    }
    
    func loadNextPage() {
        if !isLoading && hasMoreArticles {
            getArticles(page: currentPage + 1)
        }
    }
    
    func clearArticles() {
        articles = []
        currentPage = 1
        hasMoreArticles = true
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
        }
    }
}
