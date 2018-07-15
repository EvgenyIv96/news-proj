//
//  NewsDetailRequestData.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

struct NewsDetailRequestData: WebRequestData {
        
    private(set) var baseURL = URL(string: ApplicationConstants.WebConstants.baseURLString)!
    private(set) var path = "getArticle"
    private(set) var httpMethod = HTTPMethod.get
    private(set) var headers: HTTPHeaders = [:]
    private(set) var urlParameters: HTTPParameters
    private(set) var bodyParameters: HTTPParameters = [:]
    
    init(slug: String) {
        urlParameters = ["urlSlug": slug]
    }
    
}
