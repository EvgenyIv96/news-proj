//
//  NetworkActivityIndicatorController.swift
//  news-proj
//
//  Created by Евгений Иванов on 19.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

protocol NetworkActivityIndicatorController {
    
    /// Method is used to show or hide network activity indicator.
    ///
    /// - Parameter visible: Visibility flag. True if network activity indicator should be showed, otherwise false.
    func setNetworkActivityIndicatorVisible(_ visible: Bool)
    
}

extension NetworkActivityIndicatorController {
    func setNetworkActivityIndicatorVisible(_ visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
}
