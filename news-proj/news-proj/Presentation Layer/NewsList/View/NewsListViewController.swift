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
    
    fileprivate var cellModels: [NewsListCellModel]?
    
    @IBOutlet fileprivate var tableView: UITableView!
    
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

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let newsCell = cell as? NewsListCell, let cellModel = cellModels?[indexPath.row] else { return }
        
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
        return cellModels?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newsListCell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.reuseIdentifier, for: indexPath)
        
        return newsListCell
        
    }

    
}

// MARK: - NewsListViewInput
extension NewsListViewController: NewsListViewInput {
    
    func setupInitialState() {
        navigationItem.title = ScreenName
    }
    
    func setNetworkActivityIndicatorVisible(_ visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
    
    func setPullToRefreshLoadingIndicatorVisible(_ visible: Bool) {
        
    }
    
    func setBottomLoadingIndicatorVisible(_ visible: Bool) {
        
    }
    
    func updateCellModels(_ cellModels: [NewsListCellModel], shouldReloadTableView: Bool) {
        
        self.cellModels = cellModels
        
        if shouldReloadTableView {
            tableView.reloadData()
        }
        
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

// MARK: - NewsListModuleRouting
extension NewsListViewController: NewsListModuleRouting {
    
}
