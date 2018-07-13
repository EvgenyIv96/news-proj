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
    
    /// Method is used to tell delegate that given news object was changed.
    ///
    /// - Parameters:
    ///   - newsPlainObject: Changed object
    ///   - changeType: Change type
    ///   - index: Index of changed news. Used in delete, update and move changes.
    ///   - newIndex: New index of changed news. Used only in insert and move changes.
    func newsListServiceDidChangeNews(newsPlainObject: NewsPlainObject, changeType: NewsListChangeType, index: Int?, newIndex: Int?)
    
    /// Method is used to notify delegate that news were updated.
    func newsListServiceDidUpdateNews()
    
}
