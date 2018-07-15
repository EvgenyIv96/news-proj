//
//  NewsListModuleRouting.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

protocol NewsListModuleRouting: class {
    
    /// Method is used to open news detail module and configure it with given permanent news managed object id.
    ///
    /// - Parameter newsObjectID: Permanent managed object id.
    func openNewsDetailModule(with newsObjectID: NSManagedObjectID)
    
}
