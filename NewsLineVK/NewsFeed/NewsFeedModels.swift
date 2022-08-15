//
//  NewsFeedModels.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 06.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewsFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsfeed(feed: FeedResponse, revealdedPostId: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsfeed(feedViewModel: FeedViewModel)
                case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
    
}

struct UserViewModel: TitleViewViewModelProtocol {
    var photoUrlString: String?
}

struct FeedViewModel {
    struct CellModel: CellFeedViewModelProtocol {
        
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var repost: String?
        var views: String?
        
        var photoAttachments: [PhotoAttachmentCellFeedViewModelProtocol]
        var size: CellFeedSizeProtocol
    }
    
    struct FeedCellPhotoAttachment: PhotoAttachmentCellFeedViewModelProtocol {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [CellModel]
    
    let footerTitle: String?
}
