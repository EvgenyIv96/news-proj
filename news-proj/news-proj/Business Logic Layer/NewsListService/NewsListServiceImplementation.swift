//
//  NewsListServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

final class NewsListServiceImplementation: NSObject {
    
    private weak var delegate: NewsListServiceDelegate?
    
    private let networkComponent: NetworkComponent
    private let requestBuilder: URLRequestBuilder
    private let coreDataManager: CoreDataManager
    
    private var fetchedResultsController: NSFetchedResultsController<News>?
    
    init(networkComponent: NetworkComponent, requestBuilder: URLRequestBuilder, coreDataManager: CoreDataManager, delegate: NewsListServiceDelegate?) {
        self.networkComponent = networkComponent
        self.requestBuilder = requestBuilder
        self.coreDataManager = coreDataManager
        self.delegate = delegate
    }

}

// MARK: - NewsListServiceInput
extension NewsListServiceImplementation: NewsListServiceInput {
    
    func prepare() {
        configureFetchedResultsController()
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard let count = fetchedResultsController?.sections?[section].numberOfObjects else { return 0 }
        return count
    }
    
    func newsPlainObject(at indexPath: IndexPath) -> NewsPlainObject {
        
        let news = fetchedResultsController!.object(at: indexPath)
        
        return NewsPlainObject(with: news)
        
    }

    func newsObjectIDForObject(at indexPath: IndexPath) -> NSManagedObjectID {
        
        let news = fetchedResultsController!.object(at: indexPath)
        
        return coreDataManager.permanentObjectID(for: news)!
        
    }
    
    func reloadNews(pageSize: Int, completion: @escaping (NewsListServiceResult) -> ()) {
        
        let pageOffset = 0
        
        guard let webRequest = createWebRequest(with: pageOffset, pageSize: pageSize) else { return }
        
        // Cancelling previous request
        networkComponent.cancel()
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(error: nil, humanReadableErrorText: ApplicationConstants.WebConstants.internetConnectionError))
        }
        
        networkComponent.makeRequest(request: webRequest) { [weak self] (task, data, response, error) in
            
            guard let strongSelf = self, task?.state != .canceling else { return }
            
            if let error = error as NSError? {
                assertionFailure("\(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsListResponse = try self?.decodeResponseData(responseData)
                
                guard let decodedResponse = newsListResponse else { return }
                
                strongSelf.coreDataManager.save(block: { [weak self] (workerContext) in
                    
                    guard let strongSelf = self else { return }
                    
                    // Deleting old objects
                    do {
                        try strongSelf.deleteAllNews(in: workerContext)
                    } catch {
                        
                        return
                    }
                    
                    // Storing new objects
                    strongSelf.storeNews(from: decodedResponse, into: workerContext)
                    
                }, completion: { (success, error) in
                    
                    let isAllContentShowed = strongSelf.isAllContentShown(for: decodedResponse.response.totalCount, loadedCount: pageOffset + pageSize)
                    
                    let nextPageOffset = isAllContentShowed ? nil : pageOffset + pageSize
                    
                    if success {
                        completion(.success(nextPageOffset: nextPageOffset))
                    } else {
                        completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                    }
                    
                })
                
            } catch let error as NSError {
                assertionFailure("Decoding response data error: \(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
        }
        
    }

    func obtainNews(pageOffset: Int, pageSize: Int, completion: @escaping (NewsListServiceResult) -> ()) {
        
        guard let webRequest = createWebRequest(with: pageOffset, pageSize: pageSize) else { return }
        
        // Cancelling previous request
        networkComponent.cancel()
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(error: nil, humanReadableErrorText: ApplicationConstants.WebConstants.internetConnectionError))
        }
        
        networkComponent.makeRequest(request: webRequest) { [weak self] (task, data, response, error) in
            
            guard let strongSelf = self, task?.state != .canceling else { return }
            
            if let error = error as NSError? {
                assertionFailure("\(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsListResponse = try strongSelf.decodeResponseData(responseData)
                
                strongSelf.coreDataManager.save(block: { [weak self] (workerContext) in
                    
                    guard let strongSelf = self else { return }
                    
                    // Storing new objects
                    strongSelf.storeNews(from: newsListResponse, into: workerContext)
                    
                    }, completion: { (success, error) in
                        
                        let isAllContentShowed = strongSelf.isAllContentShown(for: newsListResponse.response.totalCount, loadedCount: pageOffset + pageSize)
                        
                        let nextPageOffset = isAllContentShowed ? nil : pageOffset + pageSize
                        
                        if success {
                            completion(.success(nextPageOffset: nextPageOffset))
                        } else {
                            completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                        }
                        
                })
                
            } catch let error as NSError {
                assertionFailure("Decoding response data error: \(error) \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
        }
        
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension NewsListServiceImplementation: NSFetchedResultsControllerDelegate {
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            delegate?.newsListServiceDidChangeNews(changeType: .insert, indexPath: nil, newIndexPath: newIndexPath)
        case .delete:
            delegate?.newsListServiceDidChangeNews(changeType: .delete, indexPath: indexPath, newIndexPath: nil)
        case .update:
            delegate?.newsListServiceDidChangeNews(changeType: .update, indexPath: indexPath, newIndexPath: nil)
        case .move:
            delegate?.newsListServiceDidChangeNews(changeType: .move, indexPath: indexPath, newIndexPath: newIndexPath)
        }
        
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.newsListServiceWillUpdateNews()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.newsListServiceDidUpdateNews()
    }
    
}

// MARK: - Private
extension NewsListServiceImplementation {
    
    private func configureFetchedResultsController() {
        
        let fetchRequest = News.sortedNewsFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataManager.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            assertionFailure("Fetched results controller fetch error: \(error) \(error.userInfo)")
        }
        
    }
    
    private func decodeResponseData(_ data: Data) throws -> NewsListResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full())
        let newsListResponse = try decoder.decode(NewsListResponse.self, from: data)
        return newsListResponse
    }
    
    private func createWebRequest(with pageOffset: Int, pageSize: Int) -> URLRequest?  {
        
        let requestData = NewsListRequestData(pageOffset: pageOffset, pageSize: pageSize)
        
        do {
            return try requestBuilder.buildRequest(with: requestData)
        } catch let error as NSError {
            assertionFailure("\(error) \(error.userInfo)")
        }
        
        return nil
        
    }
    
    private func storeNews(from response: NewsListResponse, into context: NSManagedObjectContext) {
        
        response.response.news.forEach {
            let news = News.insert(into: context)
            news.fill(with: $0)
        }
        
    }
    
    private func deleteAllNews(in context: NSManagedObjectContext) throws {
        
        let fetchRequest = News.newsFetchRequest()
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = false
    
        let oldNewsArray = try context.fetch(fetchRequest)
        
        oldNewsArray.forEach {
            context.delete($0)
        }
        
    }
    
    private func isAllContentShown(for totalCount: Int, loadedCount: Int) -> Bool {
        return !(totalCount - loadedCount > 0)
    }
    
}
