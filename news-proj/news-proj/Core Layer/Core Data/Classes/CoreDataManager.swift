//
//  CoreDataStack.swift
//  news-proj
//
//  Created by Евгений Иванов on 13.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

public typealias CoreDataManagerSaveCompletion = (_ contextDidSave: Bool, _ error: Error?) -> ()

public class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    private(set) var mainContext: NSManagedObjectContext!
    private var backgroundWriterContext: NSManagedObjectContext!
    
    public func createCoreDataStack(completion: @escaping () -> () ) {
        
        // Model initialization
        let modelURL = Bundle.main.url(forResource: ApplicationConstants.CoreDataConstants.modelName, withExtension: "momd")!
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
            let storeURL = documentDirectory.appendingPathComponent(ApplicationConstants.CoreDataConstants.storeName)
            
            do {
                try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [:])
            } catch {
                if let error = error as NSError? {
                    fatalError("Error \(error) \(error)")
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
            
        }
        
    }
    
    /// Method is used to save changes which was made in main context.
    ///
    /// - Parameter completion: Completion closure.
    public func saveChanges(completion: CoreDataManagerSaveCompletion? = nil) {
        
        mainContext.perform {
            
            do {
                if self.mainContext.hasChanges {
                    try self.mainContext.save()
                } else {
                    DispatchQueue.main.async {
                        completion?(false, nil)
                    }
                }
            } catch {
                if let error = error as NSError? {
                    print(error)
                }
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
                            completion?(false, nil)
                        }
                    }
                    
                } catch {
                    
                    if let error = error as NSError? {
                        print(error)
                    }
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
    public func save(block: @escaping (_ workerContext: NSManagedObjectContext)->(), completion: CoreDataManagerSaveCompletion? = nil) {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        
        context.perform { [unowned self] in
            
            block(context)
            
            do {
                
                if context.hasChanges {
                    try context.save()
                } else {
                    DispatchQueue.main.async {
                        completion?(false, nil)
                    }
                }
                
                self.saveChanges(completion: completion)

            } catch {
                
                if let error = error as NSError? {
                    print(error)
                }
                DispatchQueue.main.async {
                    completion?(false, error)
                }
                
            }

        }
        
    }
    
}
