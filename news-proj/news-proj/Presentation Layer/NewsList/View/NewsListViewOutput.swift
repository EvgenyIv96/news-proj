//
//  NewsListViewOutput.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsListViewOutput: class {
    
    /// Method is used to tell presenter that view ready for work.
    func didTriggerViewReadyEvent()
    
    // MARK: Data
    
    /// Method asks presenter for number of items in given section.
    ///
    /// - Parameter section: Section index.
    /// - Returns: Number of items.
    func numberOfItems(in section: Int) -> Int
    
    /// Method asks presenter for cell model for row at given index path.
    ///
    /// - Parameter indexPath: Index path
    /// - Returns: Cell model for given index path.
    func cellModel(forItemAt indexPath: IndexPath) -> NewsListCellModel
    
    /// Method is used to tell presenter that item at given index path was selected.
    func didTriggerItemAtIndexPathSelectedEvent(_ indexPath: IndexPath)
    
    /// Method is used to tell presenter that pull to refresh action was triggered.
    func didTriggerPullToRefreshAction()
    
    /// Method tells presenter that infinite scrolling action was triggered.
    func didTriggerInfiniteScrollingAction()
    
}
