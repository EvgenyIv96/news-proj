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
    
    fileprivate var newsPlainObjects = [NewsPlainObject]()
    fileprivate var cellModels = [NewsListCellModel]()
    fileprivate var currentNewsListPage: Int = 0

}

// MARK: - NewsListViewOutput
extension NewsListPresenter: NewsListViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        view.setupInitialState()
        
//        newsListService.loadCachedNews()

    }
    
    func didTriggerItemAtIndexPathSelectedEvent(_ indexPath: IndexPath) {
        let selectedNewsPlainObject = newsPlainObjects[indexPath.row]
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

    func newsListServiceDidChangeNews(newsPlainObject: NewsPlainObject, changeType: NewsListChangeType, index: Int?, newIndex: Int?) {
        
        let cellModel = NewsListCellModel(with: newsPlainObject)
        
        switch changeType {
        case .insert:
            
            newsPlainObjects.insert(newsPlainObject, at: newIndex!)
            cellModels.insert(cellModel, at: newIndex!)
            
            view.updateCellModels(cellModels, shouldReloadTableView: false)
            view.updateTableViewRow(updateType: .insert, indexPath: nil, newIndexPath: IndexPath(row: newIndex!, section: 0))
            
        case .delete:
            
            newsPlainObjects.remove(at: index!)
            cellModels.remove(at: index!)
            
            view.updateCellModels(cellModels, shouldReloadTableView: false)
            view.updateTableViewRow(updateType: .delete, indexPath: IndexPath(row: index!, section: 0), newIndexPath: nil)
            
        case .update:
            
            newsPlainObjects.modifyElement(atIndex: index!) { (oldNewsPlainObject) in
                oldNewsPlainObject = newsPlainObject
            }
            cellModels.modifyElement(atIndex: index!) { (oldCellModel) in
                oldCellModel = cellModel
            }
            
            view.updateCellModels(cellModels, shouldReloadTableView: false)
            view.updateTableViewRow(updateType: .reload, indexPath: IndexPath(row: index!, section: 0), newIndexPath: nil)
            
        case .move:
            
            newsPlainObjects.remove(at: index!)
            newsPlainObjects.insert(newsPlainObject, at: newIndex!)
            cellModels.remove(at: index!)
            cellModels.insert(cellModel, at: newIndex!)
            
            view.updateTableViewRow(updateType: .move, indexPath: IndexPath(row: index!, section: 0), newIndexPath: IndexPath(row: newIndex!, section: 0))

        }
        
    }
    
    func newsListServiceDidUpdateNews() {
        view.endTableUpdates()
    }
    
}
