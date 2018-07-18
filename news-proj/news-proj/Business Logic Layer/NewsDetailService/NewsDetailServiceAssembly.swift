//
//  NewsDetailService.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

final class NewsDetailServiceAssembly {
    
    func buildNewsDetailService(delegate: NewsDetailServiceDelegate? = nil) -> NewsDetailServiceInput {
        
        let networkComponent = NetworkComponent()
        let requestBuilder = URLRequestBuilder()
        let newsDetailService = NewsDetailServiceImplementation(networkComponent: networkComponent, requestBuilder: requestBuilder, delegate: delegate)
        
        return newsDetailService
        
    }
    
}
