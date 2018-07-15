//
//  NewsDetailServiceInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

protocol NewsDetailServiceInput: class {
    
    /// Method is used to set up service before usage. WARNING: Expected permanent managed object id!
    ///
    /// - Parameter newsObjectID: Permanent managed object id for news object.
    func setup(with newsObjectID: NSManagedObjectID)
    
    /// Method is used to obtain plain news object.
    ///
    /// - Returns: Plain news object
    func obtainNewsPlainObject() -> NewsPlainObject
    
    /// Method is used to update news data from server.
    func reloadNewsData()
    
}
