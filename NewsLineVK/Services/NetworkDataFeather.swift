//
//  NetworkDataFeather.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 03.08.2022.
//

import Foundation

protocol DataFeatherProtocol {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFeather: DataFeatherProtocol {
    
    let networking: NetworkingProtocol
    private let authService: AuthService
    
    
    init(networkingDelegate: NetworkingProtocol, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networkingDelegate
        self.authService = authService
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let parameters = ["user_ids" : userId, "fields" : "photo_100"]
        
        networking.request(path: QueryAPI.user, parameters: parameters) { data, error in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var parameters = ["filters" : "post, photo"]
        parameters["start_from"] = nextBatchFrom
        networking.request(path: QueryAPI.newsFeed, parameters: parameters) { data, error in
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
