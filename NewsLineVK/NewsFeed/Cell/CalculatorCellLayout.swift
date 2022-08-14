//
//  CalculatorCellLayout.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 07.08.2022.
//

import UIKit


protocol CalculatorCellLayoutProtocol {
    func sizes(postText: String?, photoAttachments: [PhotoAttachmentCellFeedViewModelProtocol], isFullSizePost: Bool) -> CellFeedSizeProtocol
}

struct Sizes: CellFeedSizeProtocol {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

final class CalculatorCellLayout: CalculatorCellLayoutProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachments: [PhotoAttachmentCellFeedViewModelProtocol], isFullSizePost: Bool) -> CellFeedSizeProtocol {
        
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - ConstantsSizeItem.cardInsets.left - ConstantsSizeItem.cardInsets.right
        
        //MARK: - Work with postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: ConstantsSizeItem.postLabelInsets.left, y: ConstantsSizeItem.postLabelInsets.top), size: CGSize.zero)
        
        if let postText = postText, !postText.isEmpty {
            let width = cardViewWidth - ConstantsSizeItem.postLabelInsets.left - ConstantsSizeItem.postLabelInsets.right
            var height = postText.height(width: width, font: ConstantsSizeItem.postTextFont)
            
            // скрывать текст для кнопки "показать текст"
            let limitHeight = ConstantsSizeItem.postTextFont.lineHeight * ConstantsSizeItem.minifiedPostLimitLines
            
            if height > limitHeight && !isFullSizePost {
                height = ConstantsSizeItem.postTextFont.lineHeight * ConstantsSizeItem.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: - Work with moreTextButtonFrame
        
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = ConstantsSizeItem.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: ConstantsSizeItem.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)

        
        //MARK: - Work with attachmentFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? ConstantsSizeItem.postLabelInsets.top : moreTextButtonFrame.maxY+ConstantsSizeItem.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let photoAttachment = photoAttachments.first {
            let photoHeight: Float = Float(photoAttachment.height)
            let photoWidth: Float = Float(photoAttachment.width)
            let ration = CGFloat(photoHeight / photoWidth)
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth*ration)
            } else if photoAttachments.count > 1 {
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        //MARK: - Work with bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: ConstantsSizeItem.bottomViewHeight))
        
        //MARK: - Work with totalHeight

        let totalHeight = bottomViewFrame.maxY + ConstantsSizeItem.cardInsets.bottom
        
        
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
