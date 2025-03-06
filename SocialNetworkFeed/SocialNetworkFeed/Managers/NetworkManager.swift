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
    
    
    func retrieveArticles(from url: URL, completion: @escaping (Result<[Article], AFError>) -> (Void)) {
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Article].self) { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                completion(.success(response.value ?? []))
        }
    }
}
