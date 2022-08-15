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
    private lazy var footerView = FooterView()
    
    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
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
        setupTableView()
        setupTopBars()

        //view.backgroundColor = #colorLiteral(red: 0.9296012169, green: 0.9544633575, blue: 1, alpha: 1)
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
    }
    
    private func setupTableView() {
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        
        tableView.register(UINib(nibName: "CellNewsfeed", bundle: nil), forCellReuseIdentifier: CellNewsfeed.reuseId)
        tableView.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = footerView
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: NewsFeed.Model.Request.RequestType.getNewsFeed)
    }
    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
                
            case .displayNewsfeed(feedViewModel: let feedViewModel):
                self.feedViewModel = feedViewModel
                footerView.setTitle(feedViewModel.footerTitle)
                tableView.reloadData()
                refreshControl.endRefreshing()
            case .displayUser(userViewModel: let userViewModel):
                titleView.set(userViewModel: userViewModel)
            case .displayFooterLoader:
                footerView.showLoaderIndicate()
        }
    }
    
    //MARK: - Follow position content on screen
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
    
    
    //MARK: - Setting Top Bars
    
    private func setupTopBars() {
        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
        topBar.backgroundColor = .white
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.3
        topBar.layer.shadowOffset = CGSize.zero
        topBar.layer.shadowRadius = 9
        self.view.addSubview(topBar)
        
        
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
