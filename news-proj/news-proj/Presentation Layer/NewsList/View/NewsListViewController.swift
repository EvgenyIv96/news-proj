//
//  NewsListViewController.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

fileprivate let ScreenName = "Новости"

class NewsListViewController: UIViewController {
    
    var output: NewsListViewOutput!
    
    @IBOutlet fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    // MARK: Life Cycle
    override func viewDidLoad() {

        super.viewDidLoad()

        output.didTriggerViewReadyEvent()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
    
    func setNetworkActivityIndicatorVisible(_ visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
    
    func setPullToRefreshLoadingIndicatorVisible(_ visible: Bool) {
        
        if visible {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
        
    }
    
    func setInfinityScrollingEnabled(_ enabled: Bool) {
        
    }
    
    func setBottomLoadingIndicatorVisible(_ visible: Bool) {
        
    }
    
    func beginTableUpdates() {
        tableView.beginUpdates()
    }
    
    func updateTableViewRow(updateType: NewsListTableViewRowUpdateType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        
        switch updateType {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .left)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .top)
        case .reload:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .top)
            tableView.insertRows(at: [newIndexPath!], with: .left)
        }
        
    }
    
    func endTableUpdates() {
        tableView.endUpdates()
    }
    
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let newsCell = cell as? NewsListCell else { return }
        
        let cellModel = output.cellModel(forItemAt: indexPath)
        
        newsCell.configure(with: cellModel)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsListCell.height
    }
    
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
        
        let newsListCell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.reuseIdentifier, for: indexPath)
        
        return newsListCell
        
    }
    
}

// MARK: - Actions
extension NewsListViewController {
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        output.didTriggerPullToRefreshAction()
    }
    
}

// MARK: - NewsListModuleRouting
extension NewsListViewController: NewsListModuleRouting {
    
}
