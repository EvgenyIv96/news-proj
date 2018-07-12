//
//  NewsListResponse.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsListResponse: Decodable {
    struct Response {
        var news: [NewsPlainObject]
        var totalCount: Int
    }
    let response: Response
}

extension NewsListResponse.Response: Decodable {
    
    private enum ResponseCodingKey: String, CodingKey {
        case news
        case totalCount = "total"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ResponseCodingKey.self)
        
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        news = try container.decode([NewsPlainObject].self, forKey: .news)
        
    }
    
}
