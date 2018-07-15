//
//  NewsPlainObject.swift
//  news-proj
//
//  Created by Евгений Иванов on 11.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsPlainObject {
    
    let slug: String
    let title: String?
    let text: String?
    let creationDate: Date
    let viewsCount: Int16
    
    init(slug: String, title: String? = nil, text: String? = nil, creationDate: Date = Date(), viewsCount: Int16 = 0) {
        self.slug = slug
        self.title = title
        self.text = text
        self.creationDate = creationDate
        self.viewsCount = viewsCount
    }
    
    init(with news: News) {
        slug = news.slug
        title = news.title
        text = news.text
        creationDate = news.creationDate as Date
        viewsCount = news.viewsCount
    }
    
    init(with newsDetailResponse: NewsDetailResponse.NewsDetailInformation, viewsCount: Int16 = 0) {
        slug = newsDetailResponse.slug
        title = newsDetailResponse.title
        text = newsDetailResponse.text
        creationDate = newsDetailResponse.creationDate
        self.viewsCount = viewsCount
    }
    
}

extension NewsPlainObject: Decodable {
    
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
        text = nil
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        viewsCount = 0
    }
    
}
