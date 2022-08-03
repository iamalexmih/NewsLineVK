//
//  NetWorkService.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 03.08.2022.
//

import UIKit

final class NetWorkService {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func getFeed() {
        
        var componentsURL = URLComponents()
        
//https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.131
        
        guard let token = authService.token else { return } //извлекаем опционал token
        
        let parameters = ["filters" : "post,photo"]
        var allParameters = parameters
        allParameters["access_token"] = token
        allParameters["v"] = QueryAPI.version
        
        componentsURL.scheme = QueryAPI.scheme
        componentsURL.host = QueryAPI.host
        componentsURL.path = QueryAPI.newsFeed
        componentsURL.queryItems = allParameters.map { (key: String, value: String) in
                                                        URLQueryItem(name: key, value: value)
                                                    }
        
        let url = componentsURL.url!
        print(url)
        
    }
    
}
