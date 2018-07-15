//
//  NewsDetailResponse.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsDetailResponse: Decodable {
    
    private enum ResponseCodingKey: String, CodingKey {
        case news = "response"
    }
    
    let news: NewsPlainObject
    
}
