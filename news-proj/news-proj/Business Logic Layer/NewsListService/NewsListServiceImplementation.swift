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
        try! fetchedResultsController?.performFetch()
        
    }
    
}

// MARK: - NewsListServiceInput
extension NewsListServiceImplementation: NewsListServiceInput {
    
    func loadCachedNews() {
        
    }

    func reloadNews(pageSize: Int) {
        
        let requestData = NewsListRequestData(pageOffset: 0, pageSize: pageSize)
        var request: URLRequest!
        
        do {
            request = try requestBuilder.buildRequest(with: requestData)
        } catch {
            if let error = error as NSError? {
                fatalError("\(error) \(error.userInfo)")
            }
        }
        
        networkComponent.makeRequest(request: request) { [weak self] (task, data, response, error) in
            
            guard task?.state != .canceling else { return }
            
            if let error = error as NSError? {
                print(error)
            }
            
//            let httpURLResponse = response as? HTTPURLResponse {
////                httpURLResponse.
//            }
            
            if let data = data {
                do {
                    
                    let newsListResponse = try self?.decodeResponseData(data)
                    
                    CoreDataManager.shared.save(block: { (workerContext) in
                        
                        let _ = newsListResponse?.response.news.map({ (newsPlainObject) -> News in
                            
                            let news = News.insert(into: workerContext)
                            news.fill(with: newsPlainObject)
                            
                            return news
                            
                        })
                        
                    })
                    
                } catch {
                    if let error = error as NSError? {
                        print(error)
                    }
                    
                }
            }
            
        }
        
    }

    func obtainNews(pageOffset: Int, pageSize: Int) {
        
        let requestData = NewsListRequestData(pageOffset: pageOffset, pageSize: pageSize)
        let request = try! requestBuilder.buildRequest(with: requestData)
        networkComponent.makeRequest(request: request) { (task, data, response, error) in
            
        }
        
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension NewsListServiceImplementation: NSFetchedResultsControllerDelegate {
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let news = anObject as? News else { fatalError("Invalid object type!") }
        
        let newsPlainObject = NewsPlainObject(with: news)
        
        switch type {
        case .insert:
            delegate?.newsListServiceDidChangeNews(newsPlainObject: newsPlainObject, changeType: .insert, index: nil, newIndex: newIndexPath!.row)
        case .delete:
            delegate?.newsListServiceDidChangeNews(newsPlainObject: newsPlainObject, changeType: .delete, index: indexPath!.row, newIndex: nil)
        case .update:
            delegate?.newsListServiceDidChangeNews(newsPlainObject: newsPlainObject, changeType: .update, index: indexPath!.row, newIndex: nil)
        case .move:
            delegate?.newsListServiceDidChangeNews(newsPlainObject: newsPlainObject, changeType: .move, index: indexPath!.row, newIndex: newIndexPath!.row)
        }
        
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
}

// MARK: - Private
extension NewsListServiceImplementation {
    
    fileprivate func decodeResponseData(_ data: Data) throws -> NewsListResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsListResponse = try decoder.decode(NewsListResponse.self, from: data)
        return newsListResponse
    }
    
}
