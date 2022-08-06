//
//  NetworkDataFeather.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 03.08.2022.
//

import Foundation

protocol DataFeatherProtocol {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFeather: DataFeatherProtocol {
    
    let networkingDelegate: NetworkingProtocol
    
    init(networkingDelegate: NetworkingProtocol) {
        self.networkingDelegate = networkingDelegate
    }
    
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let parameters = ["filters" : "post, photo"]
        networkingDelegate.request(path: QueryAPI.newsFeed, parameters: parameters) { data, error in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
