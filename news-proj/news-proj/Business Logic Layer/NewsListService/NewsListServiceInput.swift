//
//  NewsListServiceInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsListServiceInput: class {
    
    /// Method is used to load cached news from local storage.
    func loadCachedNews()
    
    /// Method is used to reload all news. Method will obtain first part of the news list for given page size, obtained part of news will be cached. Also method removes all previosly obtained news and clears old cache. All previous runned obtaining operations will be cancelled.
    ///
    /// - Parameter pageSize: Page size
    func reloadNews(pageSize: Int)
    
    /// Method is used to obtain news with given page offset and page size. Obtained news will be cached. All previous runned obtaining operations will be cancelled.
    ///
    /// - Parameters:
    ///   - pageOffset: Page offset
    ///   - pageSize: Page size
    func obtainNews(pageOffset: Int, pageSize: Int)

}
