//
//  NewsDetailServiceDelegate.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsDetailServiceDelegate: class {
    
    /// Method tells delegate that news object was updated
    ///
    /// - Parameter updatedNewsPlainObject: Updated version of news plain object
    func newsObjectWasUpdated(updatedNewsPlainObject: NewsPlainObject)
    
    /// Method tells delegate that news object was deleted
    func newsObjectWasDeleted()
    
}
