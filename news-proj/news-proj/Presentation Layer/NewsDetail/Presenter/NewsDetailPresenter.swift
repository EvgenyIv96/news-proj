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
        view.configure(screenName: newsPlainObject.title ?? "")
        view.configure(htmlText: newsPlainObject.text ?? "")
        
        newsDetailService.incrementViewsCount()
        
        view.setNetworkActivityIndicatorVisible(true)
        
        newsDetailService.getNewsData { [weak self] (result) in
            
            switch result {
            case .success:
                break
            case .failure(let error, let errorMessage):
                if let error = error as NSError? {
                    print("\(error) \(error.userInfo)")
                }
                self?.view.showErrorMessage(errorMessage)
            }
            
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
    
    func newsObjectWasUpdated(updatedNewsPlainObject: NewsPlainObject) {
        view.configure(screenName: updatedNewsPlainObject.title ?? "")
        view.configure(htmlText: updatedNewsPlainObject.text ?? "")
    }
    
    func newsObjectWasDeleted() {
        router.close()
    }
    
}

// MARK: - Private
extension NewsDetailPresenter {
    
}
