//
//  ArticleDetailViewModel.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import Foundation
import Combine
import Alamofire

final class ArticleDetailViewModel {
    
    let commentsPublisher = PassthroughSubject<[Comment], AFError>()
    
    func getCommentsFor(article ID: Int) {
        guard let url = Endpoint.commentsForArticle(id: ID).url else { return }
        NetworkManager.shared.retrieveComments(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let fetchedComments):
                self.commentsPublisher.send(fetchedComments)
            case .failure(let error):
                self.commentsPublisher.send(completion: .failure(error))
            }
        }
    }
}
