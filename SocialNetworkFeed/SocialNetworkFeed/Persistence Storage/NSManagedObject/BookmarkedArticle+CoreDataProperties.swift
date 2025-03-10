//
//  BookmarkedArticle+CoreDataProperties.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 09.03.2025.
//
//

import Foundation
import CoreData


extension BookmarkedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedArticle> {
        return NSFetchRequest<BookmarkedArticle>(entityName: "BookmarkedArticle")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var commentsCount: Int32
    @NSManaged public var publicReactionsCount: Int32
    @NSManaged public var positiveReactionsCount: Int32
    @NSManaged public var coverImage: String?
    @NSManaged public var user: BookmarkedUser?

}

extension BookmarkedArticle : Identifiable {

}
