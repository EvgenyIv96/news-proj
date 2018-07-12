//
//  NewsListPresenter.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsListPresenter {
    
    weak var view: NewsListViewInput!
    
    weak var router: NewsListModuleRouting!

}

// MARK: - NewsListViewOutput
extension NewsListPresenter: NewsListViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        view.setupInitialState()

    }
    
}

// MARK: - NewsListModuleInput
extension NewsListPresenter: NewsListModuleInput {

    func configureModule() {

    }

}
