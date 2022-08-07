//
//  CellNewsfeed.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 06.08.2022.
//

import UIKit

protocol CellFeedViewModelProtocol {
    
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var repost: String? { get }
    var views: String? { get }
    var photoAttachment: PhotoAttachmentCellFeedViewModelProtocol? { get }
    var size: CellFeedSizeProtocol { get }
}

protocol CellFeedSizeProtocol {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol PhotoAttachmentCellFeedViewModelProtocol {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

class CellNewsfeed: UITableViewCell {
    
    static let reuseId = "CellNewsfeed"
    
    
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var iconImageView: WebImageView! // imageOwnPost
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var labelNameOwnPost: UILabel!
    @IBOutlet weak var labelDataPost: UILabel!
    @IBOutlet weak var labelPost: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelRepost: UILabel!
    @IBOutlet weak var labelViewsPost: UILabel!
    
    func setDesignCell() {
        iconImageView.layer.cornerRadius = iconImageView.frame.width/2
        iconImageView.clipsToBounds = true
        
        postImageView.layer.cornerRadius = 10
        postImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDesignCell()
    }
    
    func set(viewModel: CellFeedViewModelProtocol) {
        
        iconImageView.set(imageURL: viewModel.iconUrlString)
        
        labelNameOwnPost.text = viewModel.name
        labelDataPost.text = viewModel.date
        labelPost.text = viewModel.text
        labelLikes.text = viewModel.likes
        labelComments.text = viewModel.comments
        labelRepost.text = viewModel.repost
        labelViewsPost.text = viewModel.views
        
        labelPost.frame = viewModel.size.postLabelFrame
        postImageView.frame = viewModel.size.attachmentFrame
        bottomView.frame = viewModel.size.bottomViewFrame
        
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
    
    
    
}
