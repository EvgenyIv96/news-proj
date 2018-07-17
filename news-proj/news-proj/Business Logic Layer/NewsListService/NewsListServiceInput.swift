//
//  NewsListServiceInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

enum NewsListServiceResult {
    case success(nextPageOffset: Int?)
    case failure(error: Error?, humanReadableErrorText: String)
}

protocol NewsListServiceInput: class {
    
    /// Method is used to prepare service for working. Call this method once before using. After prepearing service automatically will give cached news using appropriate delegate methods.
    func prepare()
    
    /// Method asks service for news items count in given section.
    ///
    /// - Parameter section: Section index.
    /// - Returns: Number of items.
    func numberOfItems(in section: Int) -> Int
    
    /// Method asks service for news plain object at given index path.
    ///
    /// - Parameter indexPath: Index path
    /// - Returns: News plain object for given index path.
    func newsPlainObject(at indexPath: IndexPath) -> NewsPlainObject
    
    /// Method is used to obtain permanent managed object id for news object at given index path.
    ///
    /// - Parameter indexPath: Index path.
    /// - Returns: Permanent managed object id.
    func newsObjectIDForObject(at indexPath: IndexPath) -> NSManagedObjectID

    /// Method is used to reload all news. Method will obtain first part of the news list for given page size, obtained part of news will be cached. Also method removes all previosly obtained news and clears old cache. All previous runned obtaining operations will be cancelled.
    ///
    /// - Parameters:
    /// - Parameter pageSize: Page size
    ///   - completion: Completion handler. In success case next page offset may be nil if all news has already loaded.
    func reloadNews(pageSize: Int, completion: @escaping (NewsListServiceResult) -> ())
    
    /// Method is used to obtain news with given page offset and page size. Obtained news will be cached. All previous runned obtaining operations will be cancelled.
    ///
    /// - Parameters:
    ///   - pageOffset: Page offset
    ///   - pageSize: Page size
    ///   - completion: Completion handler. In success case next page offset may be nil if all news has already loaded.
    func obtainNews(pageOffset: Int, pageSize: Int, completion: @escaping (NewsListServiceResult) -> ())

}
