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
        
        guard let newsCell = cell as? NewsListCell else { return }
        
        // Configure cell here
        
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
        return 0
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
    
}

// MARK: - NewsListModuleRouting
extension NewsListViewController: NewsListModuleRouting {
    
}
