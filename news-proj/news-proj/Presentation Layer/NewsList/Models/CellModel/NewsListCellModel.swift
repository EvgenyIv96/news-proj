//
//  NewsListCellModel.swift
//  news-proj
//
//  Created by Евгений Иванов on 13.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsListCellModel {
    var title: String
    var viewsCountString: String
    
    init(with newsPlainObject: NewsPlainObject) {
        self.title = newsPlainObject.title ?? ""
        self.viewsCountString = "\(newsPlainObject.viewsCount)"
    }
    
}
