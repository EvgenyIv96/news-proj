//
//  NewsDetailServiceDelegate.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsDetailServiceDelegate: AnyObject {
    
    /// Method tells delegate that news object was updated
    ///
    /// - Parameter newsPlainObject: Updated news plain object
    func didUpdate(newsPlainObject: NewsPlainObject)
    
    /// Method tells delegate that news object was deleted
    func didDeleteNewsObject()
    
}
