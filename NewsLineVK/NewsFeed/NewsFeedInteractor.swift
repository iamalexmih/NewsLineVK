//
//  NewsFeedInteractor.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 06.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    private var fetcherDelegate: DataFeatherProtocol = NetworkDataFeather(networkingDelegate: NetWorkService())
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
            case .getNewsFeed:
                
                fetcherDelegate.getFeed { [weak self] feedResponse in
                    guard let feedResponse = feedResponse else { return }
                    feedResponse.profiles.map { profile in
                    }
                    self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsfeed(feed: feedResponse))
                }
        }
    }
    
}
