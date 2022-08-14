//
//  GalleryColletcionView.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 11.08.2022.
//

import UIKit



class GalleryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    var photos = [PhotoAttachmentCellFeedViewModelProtocol]()
    
    
    init() {
        let rowLayout = RowLayout()
        
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .white
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseId)
        
        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
    }
    
    func set(photos: [PhotoAttachmentCellFeedViewModelProtocol]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
//        cell.layer.cornerRadius = 10
//        cell.clipsToBounds = true
        
        return cell
    }
  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GalleryCollectionView: RowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
    
}


