//
//  BookmarkedUser+CoreDataProperties.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 07.03.2025.
//
//

import Foundation
import CoreData


extension BookmarkedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedUser> {
        return NSFetchRequest<BookmarkedUser>(entityName: "BookmarkedUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var githubUsername: String?
    @NSManaged public var userID: Int32
    @NSManaged public var profileImage90: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var articles: NSSet?

}

// MARK: Generated accessors for articles
extension BookmarkedUser {

    @objc(addArticlesObject:)
    @NSManaged public func addToArticles(_ value: BookmarkedArticle)

    @objc(removeArticlesObject:)
    @NSManaged public func removeFromArticles(_ value: BookmarkedArticle)

    @objc(addArticles:)
    @NSManaged public func addToArticles(_ values: NSSet)

    @objc(removeArticles:)
    @NSManaged public func removeFromArticles(_ values: NSSet)

}

extension BookmarkedUser : Identifiable {

}
