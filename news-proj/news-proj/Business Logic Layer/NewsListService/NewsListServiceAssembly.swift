//
//  NewsListServiceAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

final class NewsListServiceAssembly {
    
    func buildNewsListService(delegate: NewsListServiceDelegate?) -> NewsListServiceInput {
        
        let networkComponent = NetworkComponent()
        let requestBuilder = URLRequestBuilder()
        let coreDataManager = CoreDataManager.shared
        let newsListService = NewsListServiceImplementation(networkComponent: networkComponent, requestBuilder: requestBuilder, coreDataManager: coreDataManager, delegate: delegate)
        
        return newsListService
        
    }
    
}
