//
//  ParametersEncoder.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol HTTPParametersEncoder {
    
    /// Method is used to encode HTTP parameters and append it to the given url request. Method also will append appropriate headers for the request if they haven't already set. If given HTTP parameters parameter will be empty method doesn't make any changes.
    ///
    /// - Parameters:
    ///   - urlRequest: Url request to which given htttp parameters will be appended.
    ///   - parameters: Http parameters.
    func encode(urlRequest: inout URLRequest, with parameters: HTTPParameters) throws
}
