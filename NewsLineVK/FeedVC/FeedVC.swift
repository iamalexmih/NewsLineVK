//
//  FeedVC.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 02.08.2022.
//

import UIKit

class FeedVC: UIViewController {
    
    private let networkService = NetWorkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getFeed()
        view.backgroundColor = .magenta
    }
}
