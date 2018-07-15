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
    
    var newsDetailService: NewsDetailServiceInput!
    
}

// MARK: - NewsDetailViewOutput
extension NewsDetailPresenter: NewsDetailViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        view.setupInitialState()
        
        let newsPlainObject = newsDetailService.obtainNewsPlainObject()
        
        let screenName = newsPlainObject.title ?? ""
        view.configure(screenName: screenName)
        
        newsDetailService.incrementViewsCount()
        
        view.setNetworkActivityIndicatorVisible(true)
        
        newsDetailService.getNewsData { [weak self] (result) in
            
            self?.view.setNetworkActivityIndicatorVisible(false)
            
        }
        
    }
    
}

// MARK: - NewsDetailModuleInput
extension NewsDetailPresenter: NewsDetailModuleInput {

    func configureModule(with newsObjectID: NSManagedObjectID) {
        newsDetailService.setup(with: newsObjectID)
    }

}

// MARK: - NewsDetailServiceDelegate
extension NewsDetailPresenter: NewsDetailServiceDelegate {
    
}

// MARK: - Private
extension NewsDetailPresenter {
    
}
