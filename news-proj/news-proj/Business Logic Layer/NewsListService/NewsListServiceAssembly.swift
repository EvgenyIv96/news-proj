//
//  NewsListServiceAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsListServiceAssembly {
    
    func buildNewsListService(delegate: NewsListServiceDelegate?) -> NewsListServiceInput {
        
        // Creating components
        let newsListService = NewsListServiceImplementation()
        let networkComponent = NetworkComponent()
        let requestBuilder = URLRequestBuilder()
        
        // Injecting properties
        newsListService.delegate = delegate
        newsListService.networkComponent = networkComponent
        newsListService.requestBuilder = requestBuilder
        
        return newsListService
        
    }
    
}
