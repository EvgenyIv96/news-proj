//
//  News+CoreDataProperties.swift
//  news-proj
//
//  Created by Евгений Иванов on 11.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//
//

import Foundation
import CoreData

extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var slug: String
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var viewsCount: Int16
    @NSManaged public var creationDate: NSDate

}
