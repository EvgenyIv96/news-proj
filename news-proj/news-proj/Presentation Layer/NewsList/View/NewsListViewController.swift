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

// MARK: - NewsListViewInput
extension NewsListViewController: NewsListViewInput {
    
    func setupInitialState() {
        navigationItem.title = ScreenName
    }
    
}

// MARK: - NewsListModuleRouting
extension NewsListViewController: NewsListModuleRouting {
    
}
