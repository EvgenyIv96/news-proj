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
        
        newsListService.prepare()
//        let cachedNews = newsListService.loadCachedNews()
        
//        let cachedNewsPlainObjects = cachedNews?.map({ (news) -> NewsPlainObject in
//            let newsPlainObject = NewsPlainObject(with: news)
//            return newsPlainObject
//        })
//        if let cachedNewsPlainObjects = cachedNewsPlainObjects {
//            newsPlainObjects = cachedNewsPlainObjects
//            cellModels = newsPlainObjects.map({ (newsPlainObject) -> NewsListCellModel in
//                let newsListCellModel = NewsListCellModel(with: newsPlainObject)
//                return newsListCellModel
//            })
//        }
        
        newsListService.reloadNews(pageSize: PageSize)

    }
    
    func numberOfItems(in section: Int) -> Int {
        return newsListService.numberOfItems(in: section)
    }

    func cellModel(forItemAt indexPath: IndexPath) -> NewsListCellModel {
        
        let newsPlainObject = newsListService.newsPlainObject(at: indexPath)
        
        let cellModel = NewsListCellModel(with: newsPlainObject)
        
        return cellModel
        
    }
    
    func didTriggerItemAtIndexPathSelectedEvent(_ indexPath: IndexPath) {
        let selectedNewsPlainObject = newsListService.newsPlainObject(at: indexPath)
        print(selectedNewsPlainObject.slug)
    }
    
}

// MARK: - NewsListModuleInput
extension NewsListPresenter: NewsListModuleInput {

    func configureModule() {

    }

}

// MARK: - NewsListServiceOutput
extension NewsListPresenter: NewsListServiceDelegate {
    
    func newsListServiceWillUpdateNews() {
        view.beginTableUpdates()
    }

    func newsListServiceDidChangeNews(changeType: NewsListChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        
//        let cellModel = NewsListCellModel(with: newsPlainObject)
        
        switch changeType {
        case .insert:
            view.updateTableViewRow(updateType: .insert, indexPath: nil, newIndexPath: newIndexPath!)
        case .delete:
            view.updateTableViewRow(updateType: .delete, indexPath: indexPath!, newIndexPath: nil)
        case .update:
            view.updateTableViewRow(updateType: .reload, indexPath: indexPath!, newIndexPath: nil)
        case .move:
            view.updateTableViewRow(updateType: .move, indexPath: indexPath!, newIndexPath: newIndexPath)
        }
        
    }
    
    func newsListServiceDidUpdateNews() {
        view.endTableUpdates()
    }
    
}
