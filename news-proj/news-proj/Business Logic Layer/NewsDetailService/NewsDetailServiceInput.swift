//
//  NewsDetailServiceInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

enum NewsDetailServiceResult {
    case success
    case failure(error: Error?, humanReadableErrorText: String)
}

protocol NewsDetailServiceInput: AnyObject {
    
    /// Method is used to set up service before usage. WARNING: Expected permanent managed object id!
    ///
    /// - Parameter newsObjectID: Permanent managed object id for news object.
    func setup(with newsObjectID: NSManagedObjectID)
    
    /// Method is used to increment views count property by 1 on news managed object that was used to configure service.
    func incrementViewsCount()
    
    /// Method is used to obtain plain news object.
    ///
    /// - Returns: Plain news object
    func obtainNewsPlainObject() -> NewsPlainObject
    
    /// Method is used to get news data from server.
    ///
    /// - Parameter completion: Completion closure.
    func getNewsData(completion: @escaping (NewsDetailServiceResult) -> ())
    
}
