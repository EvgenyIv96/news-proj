//
//  NewsDetailModuleInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

protocol NewsDetailModuleInput: class {

    /// Method is used to configure module with given news object managed object identifier.
    ///
    /// - Parameter newsObjectID: Managed object ID.
    func configureModule(with newsObjectID: NSManagedObjectID)

}
