//
//  StorageManager.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 07.03.2025.
//

import UIKit
import CoreData

class StorageManager {
    
    private var managedObjectContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to cast UIApplication.shared.delegate to AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func retrieveAll() throws -> [BookmarkedArticle] {
        do {
            let fetchRequest = NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
            return try managedObjectContext.fetch(fetchRequest)
        } catch {
            throw StorageError.retrieveError
        }
    }
    
    
    func isBookmarked(articleID: Int) -> Bool {
        let fetchRequest: NSFetchRequest<BookmarkedArticle> = BookmarkedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", articleID)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking bookmark: \(error)")
            return false
        }
    }
    
    
    func addBookmark(article: Article) {
        let bookmarkedArticle = BookmarkedArticle(context: managedObjectContext)
        let bookmarkedUser = BookmarkedUser(context: managedObjectContext)
        
        bookmarkedUser.userID = Int32(article.user?.userID ?? 0)
        bookmarkedUser.name = article.user?.name
        bookmarkedUser.githubUsername = article.user?.githubUsername
        bookmarkedUser.profileImage = article.user?.profileImage
        bookmarkedUser.profileImage90 = article.user?.profileImage90
        
        
        bookmarkedArticle.id = Int32(article.id ?? 0)
        bookmarkedArticle.title = article.title
        bookmarkedArticle.body = article.description
        bookmarkedArticle.commentsCount = Int32(article.commentsCount ?? 0)
        bookmarkedArticle.positiveReactionsCount = Int32(article.positiveReactionsCount ?? 0)
        bookmarkedArticle.publicReactionsCount = Int32(article.publicReactionsCount ?? 0)
        bookmarkedArticle.user = bookmarkedUser
        
        saveContext()
    }
    
    
    func removeBookmark(articleID: Int) {
        let fetchRequest: NSFetchRequest<BookmarkedArticle> = BookmarkedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", articleID)
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            results.forEach { managedObjectContext.delete($0) }
            saveContext()
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
    
    
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
