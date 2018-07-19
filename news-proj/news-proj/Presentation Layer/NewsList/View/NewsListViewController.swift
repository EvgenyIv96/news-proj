//
//  NewsListViewController.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit
import CoreData

fileprivate let ScreenName = "Новости"

class NewsListViewController: UIViewController, ErrorAlertPresenter {
    
    var output: NewsListViewOutput!
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate weak var refreshControl: UIRefreshControl!
    fileprivate var infiniteScrollingController: InfiniteScrollingController?
    
    // MARK: Life Cycle
    override func viewDidLoad() {

        super.viewDidLoad()

        output.didTriggerViewReadyEvent()

    }

}

// MARK: - NewsListViewInput
extension NewsListViewController: NewsListViewInput {
    
    func setupInitialState() {
        
        // Setup navigation title
        navigationItem.title = ScreenName
        
        // Setup refresh control
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        
        // Register cell
        tableView.register(UINib.init(nibName: String(describing: NewsListCell.self), bundle: nil), forCellReuseIdentifier: NewsListCell.reuseIdentifier)
        
        // Cells height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = NewsListCell.height
        
        // Infinity scrolling
        infiniteScrollingController = InfiniteScrollingController.infiniteScrollingController(on: tableView, actionHandler: { [unowned self] in
            self.infiniteScrollAction()
        })
        
    }

    func setPullToRefreshLoadingIndicatorVisible(_ visible: Bool) {
        
        if visible {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
        
    }
    
    func setInfinityScrollingEnabled(_ enabled: Bool) {
        infiniteScrollingController?.infinityScrollingEnabled = enabled
    }
    
    func setBottomLoadingIndicatorVisible(_ visible: Bool) {
        
        if visible {
            infiniteScrollingController?.startAnimating()
        } else {
            infiniteScrollingController?.stopAnimation()
        }
        
    }
    
    func beginTableUpdates() {
        tableView.beginUpdates()
    }
    
    func updateTableViewRow(updateType: NewsListTableViewRowUpdateType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        
        switch updateType {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .top)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .top)
        case .reload:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .top)
            tableView.insertRows(at: [newIndexPath!], with: .top)
        }
        
    }
    
    func endTableUpdates() {
        tableView.endUpdates()
    }
    
    func showErrorMessage(_ message: String) {
        showAlert(errorMessage: message)
    }
    
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        output.didTriggerItemAtIndexPathSelectedEvent(indexPath)
        
    }
    
}

// MARK - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfItems(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.reuseIdentifier, for: indexPath)
        
        if let newsListCell = cell as? NewsListCell {
            
            let cellModel = output.cellModel(forItemAt: indexPath)
            
            newsListCell.configure(with: cellModel)
        }

        return cell
        
    }
    
}

// MARK: - Actions
extension NewsListViewController {
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        output.didTriggerPullToRefreshAction()
    }
    
    func infiniteScrollAction() {
        output.didTriggerInfiniteScrollingAction()
    }
    
}

// MARK: - NewsListModuleRouting
extension NewsListViewController: NewsListModuleRouting {
    
    func openNewsDetailModule(with newsObjectID: NSManagedObjectID) {
        
        NewsDetailModuleAssembly().buildNewsDetailModule { (viewController, moduleInput) in
            moduleInput?.configureModule(with: newsObjectID)
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
    }
    
}
