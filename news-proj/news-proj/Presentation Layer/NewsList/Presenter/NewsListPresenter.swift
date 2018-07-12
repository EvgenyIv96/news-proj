//
//  NewsListPresenter.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

fileprivate let PageSize = 20

class NewsListPresenter {
    
    weak var view: NewsListViewInput!
    
    weak var router: NewsListModuleRouting!
    
    var newsListService: NewsListServiceInput!
    
    fileprivate var currentNewsListPage: Int = 0

}

// MARK: - NewsListViewOutput
extension NewsListPresenter: NewsListViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        view.setupInitialState()
        
        newsListService.loadCachedNews()

    }
    
}

// MARK: - NewsListModuleInput
extension NewsListPresenter: NewsListModuleInput {

    func configureModule() {

    }

}

// MARK: - NewsListServiceOutput
extension NewsListPresenter: NewsListServiceOutput {
    
}
