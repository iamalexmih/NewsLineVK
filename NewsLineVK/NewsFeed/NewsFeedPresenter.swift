//
//  NewsFeedPresenter.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 06.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    var dateFormatter: DateFormatter = {
       let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
            case .presentNewsfeed(feed: let feed):
                
                let cells = feed.items.map { itemFeed in
                    cellViewModelForPresenter(from: itemFeed, profiles: feed.profiles, groups: feed.groups)
                }
                
                let feedViewModel = FeedViewModel(cells: cells)
                viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        }
        
    }
    
    private func cellViewModelForPresenter(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.CellModel {
        
        let orProfileOrGroups = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateItem = dateFormatter.string(from: date)
        
        return FeedViewModel.CellModel(iconUrlString: orProfileOrGroups.photo,
                                       name: orProfileOrGroups.name,
                                       date: dateItem,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       repost: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0))
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> profileRepresentableProtocol {
        let profilesOrGroups: [profileRepresentableProtocol] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { myProfileRepresentableProtocol -> Bool in
            myProfileRepresentableProtocol.id == normalSourceId
        }
        return profileRepresentable!
    }
}
