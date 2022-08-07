//
//  CalculatorCellLayout.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 07.08.2022.
//

import UIKit


protocol CalculatorCellLayoutProtocol {
    func sizes(postText: String?, photoAttachment: PhotoAttachmentCellFeedViewModelProtocol?) -> CellFeedSizeProtocol
}

struct Sizes: CellFeedSizeProtocol {
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
}

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    static let topViewHeight: CGFloat = 43
    static let postLabelInsets = UIEdgeInsets(top: 14+5+topViewHeight, left: 18, bottom: 15, right: 18)
    static let postTextFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 45
}

final class CalculatorCellLayout: CalculatorCellLayoutProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: PhotoAttachmentCellFeedViewModelProtocol?) -> CellFeedSizeProtocol {
        
        let cardViewWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        //MARK: - Work with postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top), size: CGSize.zero)
        
        if let postText = postText, !postText.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = postText.height(width: width, font: Constants.postTextFont)
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: - Work with attachmentFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY+Constants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let photoAttachment = photoAttachment {
            let photoHeight: Float = Float(photoAttachment.height)
            let photoWidth: Float = Float(photoAttachment.width)
            let ration = CGFloat(photoHeight / photoWidth)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth*ration)
        }
        
        //MARK: - Work with bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        var bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        
        
        //MARK: - Work with totalHeight

        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        
        
        return Sizes(bottomViewFrame: bottomViewFrame, totalHeight: totalHeight, postLabelFrame: postLabelFrame, attachmentFrame: attachmentFrame)
    }
}
