//
//  News+CoreDataClass.swift
//  news-proj
//
//  Created by Евгений Иванов on 11.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//
//

import Foundation
import CoreData

@objc(News)
class News: NSManagedObject {

    func fill(with newsPlainObject: NewsPlainObject) {
        self.slug = newsPlainObject.slug
        self.title = newsPlainObject.title
        self.text = newsPlainObject.text
        self.creationDate = newsPlainObject.creationDate as NSDate
    }
    
    static func insert(into context: NSManagedObjectContext) -> News {
        let news: News = context.insertObject()
        return news
    }
    
    static func newsFetchRequest() -> NSFetchRequest<News> {
        let fetchRequest = NSFetchRequest<News>(entityName: News.entity().name!)
        return fetchRequest
    }
    
    static func sortedNewsFetchRequest() -> NSFetchRequest<News> {
        let fetchRequest = newsFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
}


