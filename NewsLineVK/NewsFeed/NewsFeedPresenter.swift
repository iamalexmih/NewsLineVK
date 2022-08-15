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
    var calculatorCellLayoutDelegate: CalculatorCellLayoutProtocol = CalculatorCellLayout(screenWidth: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
    var dateFormatter: DateFormatter = {
       let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
            case .presentNewsfeed(feed: let feed, let revealdedPostId):
                
                let cells = feed.items.map { itemFeed in
                    cellViewModelForPresenter(from: itemFeed, profiles: feed.profiles, groups: feed.groups, revealdedPostId: revealdedPostId)
                }
                
                let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: " "), cells.count)
                
                let feedViewModel = FeedViewModel(cells: cells, footerTitle: footerTitle)
                viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
            case .presentUserInfo(user: let user):
                let userViewModel = UserViewModel(photoUrlString: user?.photo100)
                viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
                
            case .presentFooterLoader:
                viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayFooterLoader)
        }
        
    }
    
    private func cellViewModelForPresenter(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealdedPostId: [Int]) -> FeedViewModel.CellModel {
        
        let orProfileOrGroups = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateItem = dateFormatter.string(from: date)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let isFullSize = revealdedPostId.contains(feedItem.postId)
        
        let size = calculatorCellLayoutDelegate.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizePost: isFullSize)
        
        return FeedViewModel.CellModel(postId: feedItem.postId,
                                       iconUrlString: orProfileOrGroups.photo,
                                       name: orProfileOrGroups.name,
                                       date: dateItem,
                                       text: feedItem.text,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       repost: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachments: photoAttachments,
                                       size: size)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
            
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> profileRepresentableProtocol {
        let profilesOrGroups: [profileRepresentableProtocol] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { myProfileRepresentableProtocol -> Bool in
            myProfileRepresentableProtocol.id == normalSourceId
        }
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ attachement in
            attachement.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: firstPhoto.srcBIG, width: firstPhoto.width, height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap({ attachment -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.srcBIG,
                                                         width: photo.width,
                                                         height: photo.height)
        })
    }
}
