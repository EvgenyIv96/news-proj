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
    
    fileprivate var nextNewsListPage: Int? = 0 {
        
        didSet {
            if let _ = nextNewsListPage {
                view.setInfinityScrollingEnabled(true)
            } else {
                view.setInfinityScrollingEnabled(false)
            }
        }
        
    }

}

// MARK: - NewsListViewOutput
extension NewsListPresenter: NewsListViewOutput {
    
    func didTriggerViewReadyEvent() {
        
        // Prepare view for working
        view.setupInitialState()
        // Prepare news list service for working and load cached news
        newsListService.prepare()
        // Refresh news list
        didTriggerPullToRefreshAction()

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
        let selectedNewsObjectID = newsListService.newsObjectIDForObject(at: indexPath)
        router.openNewsDetailModule(with: selectedNewsObjectID)
    }
    
    func didTriggerPullToRefreshAction() {
        view.setNetworkActivityIndicatorVisible(true)
        view.setPullToRefreshLoadingIndicatorVisible(true)
        view.setBottomLoadingIndicatorVisible(false)
        view.setInfinityScrollingEnabled(false)
        
        newsListService.reloadNews(pageSize: PageSize) { [weak self] (result) in
            
            switch result {
            case .success(let nextPage):
                self?.nextNewsListPage = nextPage
            case .failure(let error, let humanReadableErrorText):
                if let error = error as NSError? {
                    print(error)
                }
                self?.view.showErrorMessage(humanReadableErrorText)
                break
            }
            
            self?.hideLoadingIndicators()
            
        }
        
    }
    
    func didTriggerInfiniteScrollingAction() {
        
        guard let nextPage = nextNewsListPage else { return }
        
        view.setNetworkActivityIndicatorVisible(true)
        view.setBottomLoadingIndicatorVisible(true)
        view.setInfinityScrollingEnabled(false)
        
        newsListService.obtainNews(pageOffset: nextPage, pageSize: PageSize) { [weak self] (result) in
            
            switch result {
            case .success(let nextPage):
                self?.nextNewsListPage = nextPage
            case .failure(let error, let humanReadableErrorText):
                if let error = error as NSError? {
                    print(error)
                }
                self?.view.showErrorMessage(humanReadableErrorText)
                break
            }
            
            self?.hideLoadingIndicators()
            
        }
        
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

// MARK: - Private
extension NewsListPresenter {
    
    fileprivate func hideLoadingIndicators() {
        view.setBottomLoadingIndicatorVisible(false)
        view.setNetworkActivityIndicatorVisible(false)
        view.setPullToRefreshLoadingIndicatorVisible(false)
    }
    
}
