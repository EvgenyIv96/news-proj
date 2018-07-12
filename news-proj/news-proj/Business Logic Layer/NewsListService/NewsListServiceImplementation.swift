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
}

extension NewsListServiceImplementation: NewsListServiceInput {
    
    func loadCachedNews() {
        
    }

    func reloadNews(pageSize: Int) {
        
    }

    func obtainNews(pageOffset: Int, pageSize: Int) {
        
    }
    
}
