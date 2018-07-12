//
//  URLParameterEncoder.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class URLParameterEncoder {
    
}

extension URLParameterEncoder: HTTPParametersEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
        
        guard !parameters.isEmpty else { return }
        guard let url = urlRequest.url else { throw HTTPParameterEncodeError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            let queryItems = parameters.map { (key: String, value: Any) -> URLQueryItem in
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                return queryItem
            }
            
            urlComponents.queryItems?.append(contentsOf: queryItems)
            
            urlRequest.url = urlComponents.url
            
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
    }
    
}
