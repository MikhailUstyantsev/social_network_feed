//
//  Comment.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 08.03.2025.
//

import Foundation

struct Comment: Decodable {
    let typeOf, idCode: String
    let createdAt: String
    let bodyHTML: String
    let user: User
    let children: [Comment]

    enum CodingKeys: String, CodingKey {
        case typeOf = "type_of"
        case idCode = "id_code"
        case createdAt = "created_at"
        case bodyHTML = "body_html"
        case user, children
    }
}
