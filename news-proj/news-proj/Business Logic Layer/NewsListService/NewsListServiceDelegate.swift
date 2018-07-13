//
//  NewsListServiceOutput.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

enum NewsListChangeType {
    case insert
    case delete
    case update
    case move
}

protocol NewsListServiceDelegate: class {
    
    /// Method is used to notify delegate that news are about to be updated and update method will called.
    func newsListServiceWillUpdateNews()
    
    /// Method is used to tell delegate that news object for specific index was changed.
    ///
    /// - Parameters:
    ///   - changeType: Change type
    ///   - indexPath: Index path of changed news. Used in delete, update and move changes.
    ///   - newIndexPath: New index path of changed news. Used only in insert and move changes.
    func newsListServiceDidChangeNews(changeType: NewsListChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)
    
    /// Method is used to notify delegate that news were updated.
    func newsListServiceDidUpdateNews()
    
}
