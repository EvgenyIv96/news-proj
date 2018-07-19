//
//  NewsDetailServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

final class NewsDetailServiceImplementation {
    
    private weak var delegate: NewsDetailServiceDelegate?
    
    private let networkComponent: NetworkComponent
    private let requestBuilder: URLRequestBuilder
    private let coreDataManager: CoreDataManager
    
    private let notificationCenter: NotificationCenter
    
    private var newsManagedObjectID: NSManagedObjectID!
    private var news: News?
    
    // MARK: - Initialization
    init(networkComponent: NetworkComponent, requestBuilder: URLRequestBuilder, notificationCenter: NotificationCenter, coreDataManager: CoreDataManager, delegate: NewsDetailServiceDelegate? = nil) {
        self.networkComponent = networkComponent
        self.requestBuilder = requestBuilder
        self.notificationCenter = notificationCenter
        self.coreDataManager = coreDataManager
        self.delegate = delegate
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
}

// MARK: - NewsDetailServiceInput
extension NewsDetailServiceImplementation: NewsDetailServiceInput {
    
    func setup(with newsObjectID: NSManagedObjectID) {
        newsManagedObjectID = newsObjectID
        news = coreDataManager.mainContext.object(with: newsObjectID) as? News
        setupObserving()
    }
    
    func incrementViewsCount() {
        
        coreDataManager.mainContext.perform { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.news?.viewsCount += 1
            strongSelf.coreDataManager.saveChanges()
            
        }
        
    }

    func obtainNewsPlainObject() -> NewsPlainObject {
        
        let newsPlainObject = NewsPlainObject(with: news!)

        return newsPlainObject
        
    }
    
    func getNewsData(completion: @escaping (NewsDetailServiceResult) -> ()) {
        
        let newsPlainObject = obtainNewsPlainObject()
        
        guard let webRequest = createWebRequest(slug: newsPlainObject.slug) else { return }
        
        // Cancelling previous request
        networkComponent.cancel()
                
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(error: nil, humanReadableErrorText: ApplicationConstants.WebConstants.internetConnectionError))
        }
        
        networkComponent.makeRequest(request: webRequest) { [weak self] (task, data, response, error) in
            
            guard let strongSelf = self else { return }
            guard task?.state != .canceling else { return }

            if let error = error as NSError? {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsDetailResponse = try strongSelf.decodeResponseData(responseData)
                
                let updatedNewsPlainObject = NewsPlainObject(with: newsDetailResponse.response, viewsCount: newsPlainObject.viewsCount)
                
                strongSelf.coreDataManager.mainContext.perform { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.news?.fill(with: updatedNewsPlainObject)
                    
                    strongSelf.coreDataManager.saveChanges(completion: { (success, error) in
                        if success {
                            completion(.success)
                        } else {
                            if let error = error as NSError?, error.code == CoreDataConstants.Errors.Codes.ContextHasNoChangesErrorCode {
                                completion(.success)
                            } else if let error = error as NSError? {
                                completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                            }
                        }
                    })
                }
                
            } catch let error as NSError {
                assertionFailure("Decoding response data error: \(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
        }
        
    }
    
}

// MARK: - Private
extension NewsDetailServiceImplementation {
    
    private func setupObserving() {
        
        let context = coreDataManager.mainContext
        
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: Notification) {

        guard let userInfo = notification.userInfo, let news = news else { return }

        if let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updated.contains(news) {
            let newsPlainObject = obtainNewsPlainObject()
            delegate?.didUpdate(newsPlainObject: newsPlainObject)
        }

        if let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deleted.contains(news) {
            delegate?.didDeleteNewsObject()
        }
        
        if userInfo[NSInvalidatedAllObjectsKey] != nil{
            delegate?.didDeleteNewsObject()
        } else if let invalidated = userInfo[NSInvalidatedObjectsKey] as? Set<NSManagedObject>, invalidated.contains(news) {
            delegate?.didDeleteNewsObject()
        }
        
    }
    
    private func createWebRequest(slug: String) -> URLRequest? {
        
        let requestData = NewsDetailRequestData(slug: slug)

        do {
            return try requestBuilder.buildRequest(with: requestData)
        } catch let error as NSError {
            assertionFailure("\(error) \(error.userInfo)")
        }
        
        return nil
            
    }
    
    private func decodeResponseData(_ data: Data) throws -> NewsDetailResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full())
        let newsDetailResponse = try decoder.decode(NewsDetailResponse.self, from: data)
        return newsDetailResponse
    }
    
}
