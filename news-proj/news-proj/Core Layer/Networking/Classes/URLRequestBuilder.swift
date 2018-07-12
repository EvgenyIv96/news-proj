//
//  URLRequestBuilder.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class URLRequestBuilder {
    
    fileprivate var urlParameterEncoder = URLParameterEncoder()
    fileprivate var jsonParameterEncoder = JSONParameterEncoder()
    
    func buildRequest(with requestData: WebRequestData) throws -> URLRequest {
        
        let url = requestData.baseURL.appendingPathComponent(requestData.path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: ApplicationConstants.WebConstants.timeoutInterval)
        
        request.httpMethod = requestData.httpMethod.rawValue
        
        do {
            try configureParameters(request: &request, urlParameters: requestData.urlParameters, bodyParameters: requestData.bodyParameters)
            configureHeaders(request: &request, headers: requestData.headers)
        } catch {
            
        }
        
        return request
        
    }
    
    fileprivate func configureParameters(request: inout URLRequest, urlParameters: HTTPParameters, bodyParameters: HTTPParameters) throws {
        
        do {
            try urlParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            try jsonParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
        } catch {
            throw error
        }
        
    }
    
    fileprivate func configureHeaders(request: inout URLRequest, headers: HTTPHeaders) {
        
        guard !headers.isEmpty else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
    }
    
}
