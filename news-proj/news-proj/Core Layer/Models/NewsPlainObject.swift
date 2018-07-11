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
    
}
