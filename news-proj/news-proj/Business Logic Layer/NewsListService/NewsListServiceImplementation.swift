//
//  NewsListServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsListServiceImplementation {
    weak var output: NewsListServiceOutput?
    
    var networkComponent: NetworkComponent!
    var requestBuilder: URLRequestBuilder!
    
    fileprivate var operationQueue = OperationQueue()
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

// MARK: - Private
extension NewsListServiceImplementation {
    
    fileprivate func decodeResponseData(_ data: Data) throws -> NewsListResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsListResponse = try decoder.decode(NewsListResponse.self, from: data)
        return newsListResponse
    }
    
}
