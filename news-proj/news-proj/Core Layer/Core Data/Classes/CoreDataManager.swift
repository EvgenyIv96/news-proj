//
//  CoreDataStack.swift
//  news-proj
//
//  Created by Евгений Иванов on 13.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

typealias CoreDataManagerSaveCompletion = (_ contextDidSave: Bool, _ error: Error?) -> ()

enum CoreDataConstants {
    
    fileprivate static let storeName = "Storage"
    fileprivate static let modelName = "NewsProj"
    
    enum Errors {
        enum Codes {
            static let ContextHasNoChangesErrorCode = 567
        }
    }
    
}


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    fileprivate var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    fileprivate(set) var mainContext: NSManagedObjectContext!
    fileprivate var backgroundWriterContext: NSManagedObjectContext!
    
}

// MARK: - PUBLIC
extension CoreDataManager {
    
    // MARK: Core data stack
    func createCoreDataStack(completion: @escaping () -> () ) {
        
        // Model initialization
        let modelURL = Bundle.main.url(forResource: CoreDataConstants.modelName, withExtension: "momd")!
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("model not found")
        }
        
        // Coordinator initialization
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.persistentStoreCoordinator = persistentStoreCoordinator
        
        // Contexts initialization
        let backgroundWriterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundWriterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        self.backgroundWriterContext = backgroundWriterContext
        
        let mainQueueContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainQueueContext.parent = backgroundWriterContext
        self.mainContext = mainQueueContext
        
        backgroundWriterContext.mergePolicy = NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType
        
        // Persistent store creation
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to get document directory")
            }
            let storeURL = documentDirectory.appendingPathComponent(CoreDataConstants.storeName)
            
            do {
                try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [:])
            } catch let error as NSError {
                fatalError("Error \(error) \(error)")
            }
            
            DispatchQueue.main.async {
                completion()
            }
            
        }
        
    }
    
    
    // MARK: Saving
    
    /// Method is used to save changes which was made in main context.
    ///
    /// - Parameter completion: Completion closure.
    func saveChanges(completion: CoreDataManagerSaveCompletion? = nil) {
        
        let contextHasNoChangesError = NSError(domain: ApplicationConstants.Errors.domain, code: CoreDataConstants.Errors.Codes.ContextHasNoChangesErrorCode, userInfo: nil)
        
        mainContext.perform {
            
            do {
                if self.mainContext.hasChanges {
                    try self.mainContext.save()
                } else {
                    DispatchQueue.main.async {
                        completion?(false, contextHasNoChangesError)
                    }
                }
            } catch let error as NSError {
                assertionFailure("\(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion?(false, nil)
                }
            }
            
            
            self.backgroundWriterContext.perform {
                
                do {
                    
                    if self.backgroundWriterContext.hasChanges {
                        try self.backgroundWriterContext.save()
                        DispatchQueue.main.async {
                            completion?(true, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(false, contextHasNoChangesError)
                        }
                    }
                    
                } catch let error as NSError {
                    assertionFailure("\(error) \(error.userInfo)")
                    DispatchQueue.main.async {
                        completion?(false, nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    /// Method is used to make changes in new background context and save it.
    ///
    /// - Parameters:
    ///   - block: Closure with changes.
    ///   - completion: Completion closure.
    func save(block: @escaping (_ workerContext: NSManagedObjectContext)->(), completion: CoreDataManagerSaveCompletion? = nil) {
        
        let contextHasNoChangesError = NSError(domain: ApplicationConstants.Errors.domain, code: CoreDataConstants.Errors.Codes.ContextHasNoChangesErrorCode, userInfo: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        
        context.perform { [unowned self] in
            
            block(context)
            
            do {
                
                if context.hasChanges {
                    try context.save()
                } else {
                    DispatchQueue.main.async {
                        completion?(false, contextHasNoChangesError)
                    }
                }
                
                self.saveChanges(completion: completion)
                
            } catch let error as NSError {
                assertionFailure("\(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion?(false, error)
                }
                
            }
            
        }
        
    }
    
    // MARK: Other
    func permanentObjectID(for object: NSManagedObject) -> NSManagedObjectID? {
        
        guard !object.objectID.isTemporaryID else { return object.objectID }
        
        var objectID: NSManagedObjectID?
        
        backgroundWriterContext.performAndWait { [unowned self] in
            do {
                try self.backgroundWriterContext.obtainPermanentIDs(for: [object])
                objectID = object.objectID
            } catch let error as NSError {
                assertionFailure("Can't obtain permanent object id \(error) \(error.userInfo)")
            }
        }
        
        return objectID
        
    }
    
}
