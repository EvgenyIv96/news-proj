//
//  NewsListViewInput.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

enum NewsListTableViewRowUpdateType {
    case insert
    case delete
    case move
    case reload
}

protocol NewsListViewInput: AnyObject {
    
    // MARK: Setup
    
    /// Method is used to set up view initial state.
    func setupInitialState()
    
    // MARK: Loading indicators
    
    /// Method is used to show or hide network activity indicator.
    ///
    /// - Parameter visible: Visibility flag. True if network activity indicator should be showed, otherwise false.
    func setNetworkActivityIndicatorVisible(_ visible: Bool)
    
    /// Method is used to show or hide loading indicator in the top of the table.
    ///
    /// - Parameter visible: Visibility flag. True if loading indicator should be showed, otherwise false.
    func setPullToRefreshLoadingIndicatorVisible(_ visible: Bool)
    
    /// Method is used to show or hide loading indicator in the bottom of the table.
    ///
    /// - Parameter visible: Visibility flag. True if loading indicator should be showed, otherwise false.
    func setBottomLoadingIndicatorVisible(_ visible: Bool)
    
    /// Method is used to turn on/turn off infinity scrolling.
    ///
    /// - Parameter enabled: Enabled flag. True if infinity scrolling should be turned on, otherwise false.
    func setInfinityScrollingEnabled(_ enabled: Bool)
    
    // MARK: Table view updates
    
    /// Method tells to start update news list table
    func beginTableUpdates()
    
    /// Method is used to update specific table view row. WARNING: Method doesn't change model, it's only used for redraw specific table view row. Update model with updateCellModels method before call this one.
    ///
    /// - Parameters:
    ///   - updateType: Update type
    ///   - indexPath: Index path. Used in delete, reload and move update.
    ///   - newIndexPath: New index path. Used in insert and move update.
    func updateTableViewRow(updateType: NewsListTableViewRowUpdateType, indexPath: IndexPath?, newIndexPath: IndexPath?)
    
    /// Method tells to end update news list table
    func endTableUpdates()
    
    // MARK: Errors
    
    /// Method is used to show error message
    ///
    /// - Parameter message: Error message
    func showErrorMessage(_ message: String)
    
}
