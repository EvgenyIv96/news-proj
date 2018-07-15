//
//  NewsDetailService.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsDetailServiceAssembly {
    
    func buildNewsDetailService(delegate: NewsDetailServiceDelegate? = nil) -> NewsDetailServiceInput {
        
        // Creating components
        let newsDetailService = NewsDetailServiceImplementation()
        
        // Injecting properties
        newsDetailService.delegate = delegate
        
        return newsDetailService
        
    }
    
}
