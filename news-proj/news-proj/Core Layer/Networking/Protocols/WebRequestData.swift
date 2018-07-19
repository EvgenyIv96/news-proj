//
//  WebRequestData.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

typealias HTTPParameters = [String: Any]
typealias HTTPHeaders = [String: String]

protocol WebRequestData {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var urlParameters: HTTPParameters { get }
    var bodyParameters: HTTPParameters { get }
}
