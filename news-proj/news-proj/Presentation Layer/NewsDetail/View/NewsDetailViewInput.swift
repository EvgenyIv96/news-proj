//
//  NewsDetailViewInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsDetailViewInput: class {
    
    /// Method is used to set up view initial state.
    func setupInitialState()
    
    /// Method sets up navigation title.
    ///
    /// - Parameter screenName: Navigation title.
    func configure(screenName: String)
    
    /// Method is used to configure web kit view with given html text.
    ///
    /// - Parameter htmlText: Html text string.
    func configure(htmlText: String)
    
    /// Method is used to show or hide network activity indicator.
    ///
    /// - Parameter visible: Visibility flag. True if network activity indicator should be showed, otherwise false.
    func setNetworkActivityIndicatorVisible(_ visible: Bool)
    
}
