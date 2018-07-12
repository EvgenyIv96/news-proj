//
//  NewsListServiceAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsListServiceAssembly {
    
    func buildNewsListService(output: NewsListServiceOutput?) -> NewsListServiceInput {
        
        // Creating components
        let newsListService = NewsListServiceImplementation()
        
        // Injecting properties
        newsListService.output = output
        
        return newsListService
        
    }
    
}
