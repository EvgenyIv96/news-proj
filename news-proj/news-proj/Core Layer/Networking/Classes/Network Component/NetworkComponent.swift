//
//  NetworkComponent.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

typealias NetworkComponentCompletion = (URLSessionTask?, Data?, URLResponse?, Error?) -> ()

class NetworkComponent {
    
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    func makeRequest(request: URLRequest, completion: @escaping NetworkComponentCompletion) {
        
        task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            completion(self?.task, data, response, error)
        })
        
        task?.resume()
        
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
