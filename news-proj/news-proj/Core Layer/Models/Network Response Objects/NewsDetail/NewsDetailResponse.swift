//
//  NewsDetailResponse.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsDetailResponse: Decodable {
    
    struct NewsDetailInformation {
        var slug: String
        var title: String?
        var text: String?
        var creationDate: Date
    }
    
    let response: NewsDetailInformation
    
}

extension NewsDetailResponse.NewsDetailInformation: Decodable {
    
    private enum NewsPlainObjectCodingKeys: String, CodingKey {
        case slug
        case title
        case text
        case creationDate = "createdTime"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: NewsPlainObjectCodingKeys.self)
        
        slug = try container.decode(String.self, forKey: .slug)
        title = try container.decode(String.self, forKey: .title)
        text = try container.decode(String.self, forKey: .text)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        
    }
    
}
