//
//  NewsFeedCodeCell.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 08.08.2022.
//

import UIKit

protocol NewsfeedCodeCellDelegateProtocol: AnyObject {
    func revealPost(for cell: NewsfeedCodeCell)
}

final class NewsfeedCodeCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCodeCell"
    weak var delegate: NewsfeedCodeCellDelegateProtocol?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = #colorLiteral(red: 0.8374214172, green: 0.8374213576, blue: 0.8374213576, alpha: 1)
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - Зачем эта команда. Без нее не работает addTarget
        //contentView.isUserInteractionEnabled = true
        
        overlayFirstLayer() // первый слой
        overlaySecondLayer() // второй слой
        overlayThirdLayerOnTopView() // третий слой на topView
        overlayThirdLayerOnBottomView() // третий слой на bottomView
        overlayFourthLayerOnBottomViewViews() // четвертый слой на bottomView Views
        
        moreTextButton.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    @objc func moreTextButtonTouch() {
        print("moreTextButtonTouch")

        delegate?.revealPost(for: self)
    }
    
    // MARK: - первый слой
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    //MARK: - второй слой
    let topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelPost: UILabel = {
       let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = ConstantsSizeItem.postTextFont
        label.textColor = #colorLiteral(red: 0.1725490196, green: 0.1764705882, blue: 0.1803921569, alpha: 1)
        return label
    }()
    
    let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor( #colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let galleryCollectionView = GalleryCollectionView()
    
    let bottomView: UIView = {
       let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - третий слой на topView
    
    let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = ConstantsSizeItem.topViewHeight / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let labelNameOwnPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor =  #colorLiteral(red: 0.1725490196, green: 0.1764705882, blue: 0.1803921569, alpha: 1)
        return label
    }()
    
    let labelDataPost: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - третий слой на bottomView
    
    let viewLikes: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    let viewComments: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

         return view
     }()
     
    let viewRepost: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

         return view
     }()
     
    let viewViewsPost: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
     }()
    
    // MARK: - четвертый слой на bottomView
    // Image Icon View
    let imageIconLike: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return imageView
    }()
    
    let imageIconComments: UIImageView = {
        let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(systemName: "text.bubble.rtl")
        imageView.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
         return imageView
     }()
    
    let imageIconRepost: UIImageView = {
        let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(systemName: "arrowshape.turn.up.right")
         imageView.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
         return imageView
     }()
    
    let imageIconView: UIImageView = {
        let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
         return imageView
     }()
    
    // Label
    let labelLikes: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.text = "666K"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let labelComments: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
         return label
     }()
     
    let labelRepost: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
         return label
     }()
     
    let labelViewsPost: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
         return label
     }()
     
    //MARK: - funcs
    

    
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
        bottomView.frame = viewModel.size.bottomViewFrame
        moreTextButton.frame = viewModel.size.moreTextButtonFrame
        
        if let photoAttachment = viewModel.photoAttachments.first, viewModel.photoAttachments.count == 1 {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageView.frame = viewModel.size.attachmentFrame
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.frame = viewModel.size.attachmentFrame
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.set(photos: viewModel.photoAttachments)
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
    }
    
    private func overlayFourthLayerOnBottomViewViews() {
        viewLikes.addSubview(imageIconLike)
        viewLikes.addSubview(labelLikes)
        
        viewComments.addSubview(imageIconComments)
        viewComments.addSubview(labelComments)
        
        viewRepost.addSubview(imageIconRepost)
        viewRepost.addSubview(labelRepost)
        
        viewViewsPost.addSubview(imageIconView)
        viewViewsPost.addSubview(labelViewsPost)
        
        // All constraints
        helpInForthLayer(view: viewLikes, imageView: imageIconLike, label: labelLikes)
        helpInForthLayer(view: viewComments, imageView: imageIconComments, label: labelComments)
        helpInForthLayer(view: viewRepost, imageView: imageIconRepost, label: labelRepost)
        helpInForthLayer(view: viewViewsPost, imageView: imageIconView, label: labelViewsPost)
    }
    
    private func helpInForthLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        // imageView constraints
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: ConstantsSizeItem.bottomViewIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: ConstantsSizeItem.bottomViewIconSize).isActive = true
        
        // label constraints
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 2).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(viewLikes)
        bottomView.addSubview(viewComments)
        bottomView.addSubview(viewRepost)
        bottomView.addSubview(viewViewsPost)
        //viewLikes constraints
        viewLikes.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: ConstantsSizeItem.bottomViewWidth, height: ConstantsSizeItem.bottomViewHeight))
        //viewComments constraints
        viewComments.anchor(top: bottomView.topAnchor,
                         leading: viewLikes.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: ConstantsSizeItem.bottomViewWidth, height: ConstantsSizeItem.bottomViewHeight))
        //viewRepost constraints
        viewRepost.anchor(top: bottomView.topAnchor,
                         leading: viewComments.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: ConstantsSizeItem.bottomViewWidth, height: ConstantsSizeItem.bottomViewHeight))
        //viewViewsPost constraints
        viewViewsPost.anchor(top: bottomView.topAnchor,
                         leading: nil,
                         bottom: nil,
                             trailing: bottomView.trailingAnchor,
                         size: CGSize(width: ConstantsSizeItem.bottomViewWidth, height: ConstantsSizeItem.bottomViewHeight))
    }
    
    private func overlayThirdLayerOnTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(labelNameOwnPost)
        topView.addSubview(labelDataPost)
        //iconImageView constraints
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: ConstantsSizeItem.topViewHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: ConstantsSizeItem.topViewHeight).isActive = true
        //name Label constraints
        labelNameOwnPost.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        labelNameOwnPost.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        labelNameOwnPost.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        labelNameOwnPost.heightAnchor.constraint(equalToConstant: ConstantsSizeItem.topViewHeight/2 - 2).isActive = true
        //date Label constraints
        labelDataPost.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        labelDataPost.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        labelDataPost.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        labelDataPost.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    private func overlaySecondLayer() {
        cardView.addSubview(topView)
        cardView.addSubview(labelPost)
        cardView.addSubview(moreTextButton)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(bottomView)
        //topView constraints
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 19).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -19).isActive = true
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5).isActive = true
        topView.heightAnchor.constraint(equalToConstant: ConstantsSizeItem.topViewHeight).isActive = true
        //labelPost constraints Динамический размер, задается в CalculatorCellLayout
        //moreTextButton constraints Динамический размер, задается в CalculatorCellLayout
        //postImageView constraints Динамический размер, задается в CalculatorCellLayout
        //bottomView constraints Динамический размер, задается в CalculatorCellLayout
    }
    
    private func overlayFirstLayer() {
        contentView.addSubview(cardView)
        //cardView constraints
        cardView.fillSuperview(padding: ConstantsSizeItem.cardInsets)
    }
}
