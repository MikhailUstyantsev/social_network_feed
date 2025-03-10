//
//  Functions.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 10.03.2025.
//

import Foundation

func convert(bookmarkedArticle: BookmarkedArticle) -> Article {
    let name = bookmarkedArticle.user?.name
    let username = bookmarkedArticle.user?.username
    let twitterUsername: String? = nil
    let githubUsername = bookmarkedArticle.user?.githubUsername
    let userID = Int(bookmarkedArticle.user?.userID ?? 0)
    let profileImage = bookmarkedArticle.user?.profileImage
    let profileImage90 = bookmarkedArticle.user?.profileImage90

    let user = User(
        name: name,
        username: username,
        twitterUsername: twitterUsername,
        githubUsername: githubUsername,
        userID: userID,
        profileImage: profileImage,
        profileImage90: profileImage90
    )

    let article = Article(
        id: Int(bookmarkedArticle.id),
        title: bookmarkedArticle.title,
        description: bookmarkedArticle.body,
        path: nil,
        url: nil,
        commentsCount: Int(bookmarkedArticle.commentsCount),
        publicReactionsCount: Int(bookmarkedArticle.publicReactionsCount),
        publishedTimestamp: nil,
        language: nil,
        positiveReactionsCount: Int(bookmarkedArticle.positiveReactionsCount),
        coverImage: bookmarkedArticle.coverImage,
        socialImage: nil,
        createdAt: nil,
        tagList: nil,
        tags: nil,
        user: user
    )

    return article
}
