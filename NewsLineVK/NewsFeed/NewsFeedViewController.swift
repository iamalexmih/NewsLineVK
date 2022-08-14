//
//  NewsFeedViewController.swift
//  NewsLineVK
//
//  Created by Алексей Попроцкий on 06.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic, NewsfeedCodeCellDelegateProtocol {
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    private var titleView = TitleView()
    
    private var feedViewModel = FeedViewModel(cells: [])
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTopBars()
        
        tableView.register(UINib(nibName: "CellNewsfeed", bundle: nil), forCellReuseIdentifier: CellNewsfeed.reuseId)
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        view.backgroundColor = #colorLiteral(red: 0.9296012169, green: 0.9544633575, blue: 1, alpha: 1)
        
        interactor?.makeRequest(request: .getNewsFeed)
    }
    

    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
                
            case .displayNewsfeed(feedViewModel: let feedViewModel):
                self.feedViewModel = feedViewModel
                tableView.reloadData()
        }
    }
    
    //MARK: - Setting Top Bars

    
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    //MARK: - NewsfeedCodeCellDelegateProtocol
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //MARK: - XIB Cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellNewsfeed.reuseId, for: indexPath) as! CellNewsfeed
        
        //MARK: - Code Anchor Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        
        let cellModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.size.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.size.totalHeight
    }
    
}
