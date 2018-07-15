//
//  NewsDetailPresenter.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

class NewsDetailPresenter {
    
    weak var view: NewsDetailViewInput!
    
    weak var router: NewsDetailModuleRouting!

    var news: News?
    
}

// MARK: - NewsDetailViewOutput
extension NewsDetailPresenter: NewsDetailViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        view.setupInitialState()
        
        guard let news = news else { return }
        let newsPlainObject = NewsPlainObject(with: news)
        
        let screenName = newsPlainObject.title ?? ""
        view.configure(screenName: screenName)
        
        view.setNetworkActivityIndicatorVisible(true)
        updateNews(news: news)
        
    }
    
}

// MARK: - NewsDetailModuleInput
extension NewsDetailPresenter: NewsDetailModuleInput {

    func configureModule(with newsObjectID: NSManagedObjectID) {
        news = CoreDataManager.shared.mainContext.object(with: newsObjectID) as? News
    }

}

// MARK: - Private
extension NewsDetailPresenter {
    
    fileprivate func updateNews(news: News) {
        
    }
    
}
