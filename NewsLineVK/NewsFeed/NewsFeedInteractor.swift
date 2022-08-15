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
    
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
            case .getNewsFeed:
                service?.getFeed(completion: { [weak self] (revealPostIds, feed) in
                    self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostId: revealPostIds))
                })
            case .getUser:
                service?.getUser(completion: { [weak self] user in
                    self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentUserInfo(user: user))
                })
            case .revealPostIds(postId: let postId):
                service?.revealPostIds(forPostId: postId, completion: { [weak self]  (revealPostIds, feed) in
                    self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostId: revealPostIds))
                })
            case .getNextBatch:
                print("123")
                self.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentFooterLoader)
                service?.getNextBatch(completion: { (revealPostIds, feed) in
                    self.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostId: revealPostIds))
                })
        }
    }
    
}
