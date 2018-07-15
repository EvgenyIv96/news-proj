//
//  NewsDetailServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation
import CoreData

class NewsDetailServiceImplementation: NSObject {
    
    weak var delegate: NewsDetailServiceDelegate?
    
    var networkComponent: NetworkComponent!
    var requestBuilder: URLRequestBuilder!
    
    var newsManagedObjectID: NSManagedObjectID!
    var news: News?
    
}

// MARK: - NewsDetailServiceInput
extension NewsDetailServiceImplementation: NewsDetailServiceInput {
    
    func setup(with newsObjectID: NSManagedObjectID) {
        newsManagedObjectID = newsObjectID
        news = CoreDataManager.shared.mainContext.object(with: newsObjectID) as? News
    }
    
    func incrementViewsCount() {
        CoreDataManager.shared.mainContext.perform { [weak self] in
            self?.news?.viewsCount += 1
            CoreDataManager.shared.saveChanges()
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
        
        networkComponent.makeRequest(request: webRequest) { [weak self] (task, data, response, error) in
            
            guard task?.state != .canceling else { return }

            if let error = error as NSError? {
                print(error)
            }
            
            guard let responseData = data else { return }
            
            do {
                
                let newsDetailRespone = try self?.decodeResponseData(responseData)
                
                let updatedNewsPlainObject = NewsPlainObject(with: newsDetailRespone!.response, viewsCount: newsPlainObject.viewsCount)
                
                CoreDataManager.shared.mainContext.perform { [weak self] in
                    self?.news?.fill(with: updatedNewsPlainObject)
                    CoreDataManager.shared.saveChanges(completion: { (success, error) in
                        DispatchQueue.main.async {
                            if success {
                                completion(.success)
                            } else {
                                if let error = error {
                                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                                }
                            }
                        }
                    })
                }
                
            } catch {
                if let error = error as NSError? {
                    print("Decoding response data error: \(error) \(error.userInfo)")
                }
                DispatchQueue.main.async {
                    completion(.failure(error: error, humanReadableErrorText: ApplicationConstants.WebConstants.error))
                }
            }
            
        }
        
    }
    
}

// MARK: - Private
extension NewsDetailServiceImplementation {
    
    fileprivate func setupObserving() {
        
    }
    
    fileprivate func createWebRequest(slug: String) -> URLRequest? {
        
        let requestData = NewsDetailRequestData(slug: slug)
        
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
    
    fileprivate func decodeResponseData(_ data: Data) throws -> NewsDetailResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full())
        let newsDetailResponse = try decoder.decode(NewsDetailResponse.self, from: data)
        return newsDetailResponse
    }
    
}
