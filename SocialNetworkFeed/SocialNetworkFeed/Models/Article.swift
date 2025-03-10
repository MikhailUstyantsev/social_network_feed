//
//  Article.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import Foundation

struct Article: Decodable, Hashable {
    let uniqueId = UUID()
    let id: Int?
    let title, description: String?
    let path: String?
    let url: String?
    let commentsCount, publicReactionsCount: Int?
    let publishedTimestamp: String?
    let language: String?
    let positiveReactionsCount: Int?
    let coverImage, socialImage: String?
    let createdAt: String?
    let tagList: [String]?
    let tags: String?
    let user: User?
    var isBookmarked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case path, url
        case commentsCount = "comments_count"
        case publicReactionsCount = "public_reactions_count"
        case publishedTimestamp = "published_timestamp"
        case language
        case positiveReactionsCount = "positive_reactions_count"
        case coverImage = "cover_image"
        case socialImage = "social_image"
        case createdAt = "created_at"
        case tagList = "tag_list"
        case tags, user
    }
}



struct User: Decodable, Hashable {
    let name, username, twitterUsername, githubUsername: String?
    let userID: Int?
    let profileImage, profileImage90: String?

    enum CodingKeys: String, CodingKey {
        case name, username
        case twitterUsername = "twitter_username"
        case githubUsername = "github_username"
        case userID = "user_id"
        case profileImage = "profile_image"
        case profileImage90 = "profile_image_90"
    }
}
