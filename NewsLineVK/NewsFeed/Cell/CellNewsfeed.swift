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
    
}

class CellNewsfeed: UITableViewCell {
    
    static let reuseId = "CellNewsfeed"
    
    
    @IBOutlet weak var iconImageView: WebImageView! // imageOwnPost
    @IBOutlet weak var labelNameOwnPost: UILabel!
    @IBOutlet weak var labelDataPost: UILabel!
    @IBOutlet weak var labelPost: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var labelRepost: UILabel!
    @IBOutlet weak var labelViewsPost: UILabel!
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
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
    }
    
    
    
}
