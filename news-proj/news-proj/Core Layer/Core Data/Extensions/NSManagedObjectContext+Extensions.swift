//
//  NSManagedObjectContext+Extensions.swift
//  news-proj
//
//  Created by Евгений Иванов on 13.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    public func insertObject<ManagedObject: NSManagedObject>() -> ManagedObject {
        
        guard let entityName = ManagedObject.entity().name else {
            fatalError("Can't get entity name when inserting object")
        }
        
        guard let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as? ManagedObject else {
            fatalError("Invalid object type when inserting object")
        }
        
        return object
        
    }
    
}
