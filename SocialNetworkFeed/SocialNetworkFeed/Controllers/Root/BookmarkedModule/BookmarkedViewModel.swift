//
//  BookmarkedViewModel.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import Foundation
import Combine

final class BookmarkedViewModel {
    
    let storageManager: StorageManager
    let bookmarkedPublisher = PassthroughSubject<[BookmarkedArticle], StorageError>()
    
    init(storageManager: StorageManager ) {
        self.storageManager = storageManager
    }
    
    func getBookmarkedArticles() {
        do {
            let savedArticles = try storageManager.retrieveAll()
            bookmarkedPublisher.send(savedArticles)
        } catch let error as StorageError {
            bookmarkedPublisher.send(completion: .failure(error))
        } catch {
            print("An unexpected error occurred: \(error)")
        }
      
    }
}
