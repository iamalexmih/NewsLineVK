//
//  FeedResponse.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 03.08.2022.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let text: String? //теста в посте может не быть, только фотография.
    let date: Double
    let comments: CountLikeCommentRepostViews?
    let likes: CountLikeCommentRepostViews?
    let reposts: CountLikeCommentRepostViews?
    let views: CountLikeCommentRepostViews?
    let attachments: [Attachment]?
}

struct Attachment: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getPropperSize().height
    }
    
    var width: Int {
        return getPropperSize().width
    }
    
    var srcBIG: String {
        return getPropperSize().url
    }
    
    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize //type = "z"
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
            
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountLikeCommentRepostViews: Decodable {
    let count: Int
}

protocol profileRepresentableProtocol {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, profileRepresentableProtocol {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName}
    var photo: String { return photo100 }
}

struct Group: Decodable, profileRepresentableProtocol {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
}
