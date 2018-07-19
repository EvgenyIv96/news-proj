//
//  NewsDetailModuleInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

protocol NewsDetailModuleInput: AnyObject {

    /// Method is used to configure module with given news object managed object identifier. WARNING: Expected permanent managed object id!
    ///
    /// - Parameter newsObjectID: Managed object ID.
    func configureModule(with newsObjectID: NSManagedObjectID)

}
