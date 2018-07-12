//
//  JSONParameterEncoder.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

class JSONParameterEncoder {
    
}

extension JSONParameterEncoder: HTTPParametersEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
        
        guard !parameters.isEmpty else { return }
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
        } catch {
            throw HTTPParameterEncodeError.encodingFailed
        }
        
    }
    
}
