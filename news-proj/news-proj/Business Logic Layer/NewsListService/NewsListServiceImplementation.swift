//
//  NewsListServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

class NewsListServiceImplementation: NSObject {
    
    weak var delegate: NewsListServiceDelegate?
    
    var networkComponent: NetworkComponent!
    var requestBuilder: URLRequestBuilder!
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<News>?
    
    func configureFetchedResultsController() {
        
        let fetchRequest = News.sortedNewsFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            if let error = error as NSError? {
                fatalError("Fetched results controller fetch error \(error) \(error.userInfo)")
            }
        }
        
    }
    
}

// MARK: - NewsListServiceInput
extension NewsListServiceImplementation: NewsListServiceInput {
    
    func prepare() {
        configureFetchedResultsController()
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        guard let section = fetchedResultsController?.sections?[section] else { return 0 }
        let count = section.numberOfObjects
        
        return count
        
    }
    
    func newsPlainObject(at indexPath: IndexPath) -> NewsPlainObject {
        
        let news = fetchedResultsController!.object(at: indexPath)
        
        return NewsPlainObject(with: news)
        
    }

    func reloadNews(pageSize: Int, completion: @escaping (NewsListServiceResult) -> ()) {

        let pageOffset = 0
        
        var request: URLRequest?
        do {
            request = try createWebRequest(with: pageOffset, pageSize: pageSize)
        } catch {
            completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
        }
        
        guard let webRequest = request else { return }
        
        // Cancelling previous request
        networkComponent.cancel()
        
        networkComponent.makeRequest(request: webRequest) { [weak self] (task, data, response, error) in
            
            guard task?.state != .canceling else { return }
            
            if let error = error as NSError? {
                print(error)
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsListResponse = try self?.decodeResponseData(responseData)
                
                guard let decodedResponse = newsListResponse else { return }
                
                CoreDataManager.shared.save(block: { [weak self] (workerContext) in
                    
                    // Deleting old objects
                    do {
                        try self?.deleteAllNews(in: workerContext)
                    } catch {
                        
                        return
                    }
                    
                    // Storing new objects
                    self?.storeNews(from: decodedResponse, into: workerContext)
                    
                }, completion: { (success, error) in
                    
                    guard (self != nil) else { return }
                    
                    let isAllContentShowed = self!.isAllContentShowed(for: decodedResponse.response.totalCount, pageSize: pageSize, currentOffset: pageOffset)
                    
                    let nextPage = isAllContentShowed ? nil : pageOffset + 1
                    
                    DispatchQueue.main.async {
                        if success {
                            completion(.success(nextPage: nextPage))
                        } else {
                            completion(.failure(error: error!, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                        }
                    }
                    
                })
                
            } catch {
                if let error = error as NSError? {
                    print("Decoding response data error: \(error) \(error.userInfo)")
                }
                completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
            }
        }
        
    }

    func obtainNews(pageOffset: Int, pageSize: Int, completion: @escaping (NewsListServiceResult) -> ()) {
        
        let requestData = NewsListRequestData(pageOffset: pageOffset, pageSize: pageSize)
        
        let request = try! requestBuilder.buildRequest(with: requestData)
        
        // Cancelling previous request
        networkComponent.cancel()
        
        networkComponent.makeRequest(request: request) { [weak self] (task, data, response, error) in
            
            guard task?.state != .canceling else { return }

            if let error = error as NSError? {
                print(error)
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsListResponse = try self?.decodeResponseData(responseData)
                
                guard let decodedResponse = newsListResponse else { return }
                
                CoreDataManager.shared.save(block: { [weak self] (workerContext) in
                    // Storing new objects
                    self?.storeNews(from: decodedResponse, into: workerContext)
                    }, completion: { (success, error) in
                        
                        guard (self != nil) else { return }
                        
                        let isAllContentShowed = self!.isAllContentShowed(for: decodedResponse.response.totalCount, pageSize: pageSize, currentOffset: pageOffset)
                        
                        let nextPage = isAllContentShowed ? nil : pageOffset + 1
                        
                        DispatchQueue.main.async {
                            if success {
                                completion(.success(nextPage: nextPage))
                            } else {
                                completion(.failure(error: error!, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                            }
                        }
                })
                
            } catch {
                if let error = error as NSError? {
                    print("Decoding response data error: \(error) \(error.userInfo)")
                }
                completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
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
    
    fileprivate func decodeResponseData(_ data: Data) throws -> NewsListResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full())
        let newsListResponse = try decoder.decode(NewsListResponse.self, from: data)
        return newsListResponse
    }
    
    fileprivate func createWebRequest(with pageOffset: Int, pageSize: Int) throws -> URLRequest?  {
        
        let requestData = NewsListRequestData(pageOffset: pageOffset, pageSize: pageSize)
        
        var request: URLRequest?
        
        do {
            request = try requestBuilder.buildRequest(with: requestData)
        } catch {
            if let error = error as NSError? {
                fatalError("\(error) \(error.userInfo)")
            }
        }
        
        return request
        
    }
    
    fileprivate func storeNews(from response: NewsListResponse, into context: NSManagedObjectContext) {
        
        let _ = response.response.news.map({ (newsPlainObject) -> News in
            
            let news = News.insert(into: context)
            news.fill(with: newsPlainObject)
            
            return news
            
        })
        
    }
    
    fileprivate func deleteAllNews(in context: NSManagedObjectContext) throws {
        
        let fetchRequest = News.newsFetchRequest()
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = false
    
        let oldNewsArray = try context.fetch(fetchRequest)
        
        for oldNews in oldNewsArray {
            context.delete(oldNews)
        }
        
    }
    
    fileprivate func isAllContentShowed(for totalCount: Int, pageSize: Int, currentOffset: Int) -> Bool {
        
        let loadedCount = (currentOffset + 1) * pageSize
        
        if totalCount - loadedCount > 0 {
            return false
        }
        
        return true
        
    }
    
}
