//
//  Endpoint.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}


extension Endpoint {
    
    static func publishedArticles(page: Int = 1, perPage: Int = 30) -> Endpoint {
        return Endpoint(
            path: "/api/articles",
            queryItems: [
                URLQueryItem(name: "page", value: String(describing: page)),
                URLQueryItem(name: "per_page", value: String(describing: perPage)),
            ]
        )
    }
}

extension Endpoint {
  
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dev.to"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
