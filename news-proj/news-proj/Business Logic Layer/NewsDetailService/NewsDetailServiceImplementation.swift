//
//  NewsDetailServiceImplementation.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class NewsDetailServiceImplementation: NSObject {
    
    var delegate: NewsDetailServiceDelegate?
    
    var networkComponent: NetworkComponent!
    var requestBuilder: URLRequestBuilder!
    
}

// MARK: - NewsDetailServiceInput
extension NewsDetailServiceImplementation: NewsDetailServiceInput {
    
}
