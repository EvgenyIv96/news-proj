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

extension NewsListServiceImplementation: NewsListServiceInput {
    
    func loadCachedNews() {
        
    }

    func reloadNews(pageSize: Int) {
        
        let requestData = NewsListRequestData(pageOffset: 0, pageSize: pageSize)
        let request = try! requestBuilder.buildRequest(with: requestData)
        networkComponent.makeRequest(request: request) { (data, response, error) in
            
        }
        
    }

    func obtainNews(pageOffset: Int, pageSize: Int) {
        
        let requestData = NewsListRequestData(pageOffset: pageOffset, pageSize: pageSize)
        let request = try! requestBuilder.buildRequest(with: requestData)
        networkComponent.makeRequest(request: request) { (data, response, error) in
            
        }
        
    }
    
}
