//
//  NetworkManager.swift
//  SocialNetworkFeed
//
//  Created by Mikhail Ustyantsev on 05.03.2025.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func retrieveArticles(from url: URL) -> [Article] {
        print(url)
        let urlString = url.absoluteString
        AF.request(urlString, method: .get).responseDecodable(of: [Article].self) { response in
            print(response.value)
        }
        return []
    }
}
