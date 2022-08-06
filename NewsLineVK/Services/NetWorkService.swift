//
//  NetWorkService.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 03.08.2022.
//

import UIKit

protocol NetworkingProtocol {
    func request(path: String, parameters: [String : String]?, completion: @escaping (Data?, Error?) -> Void)
}

final class NetWorkService: NetworkingProtocol {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    
    func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {

        return URLSession.shared.dataTask(with: request) { data, request, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    
    private func url(from path: String, parameters: [String : String]) -> URL {
        var componentsURL = URLComponents()
        
        componentsURL.scheme = QueryAPI.scheme
        componentsURL.host = QueryAPI.host
        componentsURL.path = path //вынесен в параметры функции, так как может понадобиться другой запрос
        componentsURL.queryItems = parameters.map { (key: String, value: String) in
                                                        URLQueryItem(name: key, value: value)
                                                    }
        return componentsURL.url!
        
    }
    
    //MARK: - func NetworkingProtocol protocol
    
    func request(path: String, parameters: [String : String]?, completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return } //извлекаем опционал token
        
        var allParameters = parameters ?? [String : String]()
        allParameters["access_token"] = token
        allParameters["v"] = QueryAPI.version
        
        let url = self.url(from: path, parameters: allParameters)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
}
